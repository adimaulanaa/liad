import 'package:liad/features/model/notes_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class NotesDatabaseService {
  // Singleton pattern
  static final NotesDatabaseService _notesDBService =
      NotesDatabaseService._internal();
  factory NotesDatabaseService() => _notesDBService;
  NotesDatabaseService._internal();
  final uuid = const Uuid();

  // Membuat ID unik
  String generateUniqueId() {
    return uuid.v4(); // Versi 4 adalah UUID berbasis random
  }

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'notes_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store user
  // and a table to store users.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE notes(_id TEXT PRIMARY KEY, title TEXT, content TEXT, images TEXT, is_checklist INTEGER, checklist_on TEXT, created_on TEXT, updated_on TEXT)',
    );
  }

  Future<List<NotesModel>> getAllNote() async {
    final db = await _notesDBService.database;
    List<NotesModel> res = [];
    // Calculate the date range for the last 7 days
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    // Query the database with a date filter
    List<Map<String, Object?>> result = await db.query(
      'notes',
      where: 'created_on >= ?',
      whereArgs: [sevenDaysAgo.toString()],
    );
    for (var e in result) {
      bool checklist = e['is_checklist'] == 1;
      res.add(
        NotesModel(
          id: e['_id']?.toString() ?? '',
          title: e['title']?.toString() ?? '',
          content: e['content']?.toString() ?? '',
          images: (e['images'] as String).split(','),
          isChecklist: int.parse(e['is_checklist']?.toString() ?? '0'),
          checklist: checklist,
          checklitsOn: e['checklist_on'] != null
              ? DateTime.tryParse(e['checklist_on'].toString()) ??
                  DateTime.now()
              : DateTime.now(),
          createdOn: e['created_on'] != null
              ? DateTime.tryParse(e['created_on'].toString()) ?? DateTime.now()
              : DateTime.now(),
          updatedOn: e['updated_on'] != null
              ? DateTime.tryParse(e['updated_on'].toString()) ?? DateTime.now()
              : DateTime.now(),
        ),
      );
    }
    return res;
  }

  Future<NotesModel> getNoteById(String id) async {
    final db = await _notesDBService.database;
    // Query berdasarkan ID
    List<Map<String, Object?>> result = await db.query(
      'notes',
      where: '_id = ?',
      whereArgs: [id],
    );
    // Jika tidak ditemukan, kembalikan null
    if (result.isEmpty) return NotesModel();
    // Ambil data pertama dari hasil
    var e = result.first;
    bool checklist = e['is_checklist'] == 1;

    return NotesModel(
      id: e['_id']?.toString() ?? '',
      title: e['title']?.toString() ?? '',
      content: e['content']?.toString() ?? '',
      images: (e['images'] as String).split(','),
      isChecklist: int.parse(e['is_checklist']?.toString() ?? '0'),
      checklist: checklist,
      checklitsOn: e['checklist_on'] != null
          ? DateTime.tryParse(e['checklist_on'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdOn: e['created_on'] != null
          ? DateTime.tryParse(e['created_on'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedOn: e['updated_on'] != null
          ? DateTime.tryParse(e['updated_on'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Future<ResponseNotes> createNotes(NotesModel dt) async {
    try {
      final db = await _notesDBService.database;
      dt.id = generateUniqueId();
      await db.insert(
        'notes',
        dt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return ResponseNotes(isSucces: true, message: 'Notes Berhasil disimpan');
    } catch (e) {
      return ResponseNotes(isSucces: false, message: 'Error: $e');
    }
  }

  Future<ResponseNotes> updateNotes(NotesModel updatedNote) async {
    try {
      final db = await _notesDBService.database;
      final result = await db.update(
        'notes',
        updatedNote.toMap(),
        where: '_id = ?',
        whereArgs: [updatedNote.id],
      );
      if (result > 0) {
        return ResponseNotes(isSucces: true, message: 'Update Berhasil');
      } else {
        return ResponseNotes(isSucces: false, message: 'Update Gagal');
      }
    } catch (e) {
      return ResponseNotes(isSucces: false, message: 'Error $e');
    }
  }

  Future<ResponseNotes> updateChecklistNotes(String id, bool check) async {
    try {
      final db = await _notesDBService.database;
      int checklist = 0;
      if (check) {
        checklist = 1;
      }
      final updatedData = <String, dynamic>{
        'is_checklist': checklist,
        'checklist_on': DateTime.now().toString(),
        'updated_on': DateTime.now().toString(),
      };
      final result = await db.update(
        'notes',
        updatedData, // Hanya mengirim kolom yang ingin diperbarui
        where: '_id = ?', // Kriteria pemilihan data berdasarkan id
        whereArgs: [id], // Nilai untuk kriteria
      );
      if (result > 0) {
        return ResponseNotes(
            isSucces: true, message: 'Update Checklist Berhasil');
      } else {
        return ResponseNotes(
            isSucces: false, message: 'Update Checklist Gagal');
      }
    } catch (e) {
      return ResponseNotes(isSucces: false, message: 'Error $e');
    }
  }

  Future<ResponseNotes> deleteNotes(String id) async {
    final db = await _notesDBService.database;
    // Query untuk memastikan data ada
    List<Map<String, Object?>> result = await db.query(
      'notes',
      where: '_id = ?',
      whereArgs: [id], // Tidak perlu konversi karena _id sudah TEXT
    );

    if (result.isEmpty) {
      return ResponseNotes(
          isSucces: false, message: 'Data not found'); // Data tidak ditemukan
    }

    // Jika data ditemukan, hapus
    await db.delete(
      'notes',
      where: '_id = ?',
      whereArgs: [id], // Hapus berdasarkan _id
    );

    return ResponseNotes(isSucces: true, message: 'Deleted successfully');
  }
}
