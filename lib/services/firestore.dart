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
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes.orderBy('time', descending: true).snapshots();

    return notesStream;
  }

  // UPDATE: update notes given a doc id
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'time': Timestamp.now()
    });
  }

  // DELETE: delete notes given a doc id
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }

}