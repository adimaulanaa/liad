import 'dart:convert';

class NotesModel {
  String? id;
  String? title;
  String? content;
  List<String>? images;
  int? isChecklist;
  bool? checklist;
  DateTime? checklitsOn;
  DateTime? createdOn;
  DateTime? updatedOn;
  bool? isSucces;

  NotesModel({
    this.id,
    this.title,
    this.content,
    this.images,
    this.isChecklist,
    this.checklist = false,
    this.checklitsOn,
    this.createdOn,
    this.updatedOn,
    this.isSucces,
  });

  // Convert a Breed into a Map. The keys must correspond to the titles of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'images': images?.join(','), // Menggabungkan daftar menjadi string
      'is_checklist': isChecklist,
      'checklist_on': checklitsOn?.toString(), // Format ke string ISO
      'created_on': createdOn?.toString(),
      'updated_on': updatedOn?.toString(),
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      images: (map['images'] as String).split(','),
      isChecklist: map['is_checklist'] ?? 0,
      checklitsOn: map['checklist_on'] != null
          ? DateTime.parse(map['checklist_on'])
          : null,
      createdOn:
          map['created_on'] != null ? DateTime.parse(map['created_on']) : null,
      updatedOn:
          map['updated_on'] != null ? DateTime.parse(map['updated_on']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'notes(_id: $id, title: $title, content: $content, images: $images, is_checklist: $isChecklist, checklist_on: $checklitsOn, created_on: $createdOn, updated_on: $updatedOn)';
}
