import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // get collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // CREATE: adding a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'time': Timestamp.now()
    });
  }

  // READ: get notes from database

  // UPDATE: update notes given a doc id

  // DELETE: delete notes given a doc id

}