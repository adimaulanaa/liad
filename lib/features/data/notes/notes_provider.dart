import 'package:flutter/material.dart';
import 'package:liad/features/data/notes/database_service.dart';
import 'package:liad/features/data/notes/notes_service.dart';
import 'package:liad/features/model/notes_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider extends ChangeNotifier {
  final NotesService dataService;
  final SharedPreferences prefs;
  final NotesDatabaseService notesDatabase;

  NotesProvider({required this.dataService, required this.prefs, required this.notesDatabase});

  Future<List<NotesModel>> getNotes() async {
    List<NotesModel> model = [];
    try {
      model = await notesDatabase.getAllNote();
      notifyListeners();
      return model;
    } catch (e) {
      return model;
    }
  }

  Future<NotesModel> getNotesId(String id) async {
    try {
      NotesModel model = await notesDatabase.getNoteById(id);
      notifyListeners();
      return model;
    } catch (e) {
      return NotesModel();
    }
  }

  Future<ResponseNotes> createNotes(NotesModel note) async {
    try {
      ResponseNotes create = await notesDatabase.createNotes(note);
      return create;
    } catch (e) {
      return ResponseNotes(isSucces: false, message: e.toString());
    }
  }


  Future<ResponseNotes> updateNotes(NotesModel note) async {
    try {
      ResponseNotes create = await notesDatabase.updateNotes(note);
      return create;
    } catch (e) {
      return ResponseNotes(isSucces: false, message: e.toString());
    }
  }

  Future<ResponseNotes> updateChecklist(String id, bool check) async {
    try {
      ResponseNotes create = await notesDatabase.updateChecklistNotes(id, check);
      return create;
    } catch (e) {
      return ResponseNotes(isSucces: false, message: e.toString());
    }
  }

  Future<ResponseNotes> deleteNotes(String id) async {
    try {
      ResponseNotes create = await notesDatabase.deleteNotes(id);
      return create;
    } catch (e) {
      return ResponseNotes(isSucces: false, message: e.toString());
    }
  }
}
