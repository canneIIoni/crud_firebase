import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Firestore
  final FirestoreService firestoreService = FirestoreService();

  // Text controller
  final TextEditingController textController = TextEditingController();

  // Open a dialog box to add a note
  void openNoteBox({String? docID}) {
    showDialog(context: context, builder: (context) => AlertDialog(
      // Text builder input
      content: TextField(
        controller: textController,
      ),
      actions: [
        // Button to save
        ElevatedButton(onPressed: () {
          // Add a new note
          if (docID == null) {
            firestoreService.addNote(textController.text);
          } else {
            firestoreService.updateNote(docID, textController.text);
          }

          // Clear the text controller
          textController.clear();

          // Dismiss popup
          Navigator.pop(context);

        }, child: Text('Add'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot> (
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // If we have data, get all the docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // Display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // Get the individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // Get note for each doc
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // Display as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openNoteBox(docID: docID),
                        icon: const Icon(Icons.settings),
                      ),
                      IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: const Icon(Icons.delete),
                      )
                    ],
                  )

                );

              },
            );
          } else {
            return const Text('No Notes');
          }
        },
      ),
    );
  }
}
