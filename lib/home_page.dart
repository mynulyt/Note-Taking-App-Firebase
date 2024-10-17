import 'package:firebase_apk/models/note_model.dart';
import 'package:firebase_apk/reposetoreis/firebase_notes_reposetoreis.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _notebodyEditnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(12.0),
              width: double.infinity,
              height: 600.0,
              child: Column(
                children: [
                  const Text(
                    "Write a note",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _titleEditingController,
                    decoration: const InputDecoration(
                        hintText: "Write your title",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _notebodyEditnController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Write your note text",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: () => FirebaseNotesReposetoreis.saveNote(
                          NoteModel(
                              id: "00",
                              title: _titleEditingController.text,
                              text: _notebodyEditnController.text)),
                      child: const Text("Save Note")),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseNotesReposetoreis.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error Loading data"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("Loading data"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data?[index].title ?? 'No Title',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              snapshot.data?[index].text ?? 'No Text',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          //for update
                          IconButton(
                            onPressed: () {
                              _titleEditingController.text =
                                  snapshot.data?[index].title ?? 'No Title';
                              _notebodyEditnController.text =
                                  snapshot.data?[index].text ?? 'No Text';
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Edit note",
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                        controller: _titleEditingController,
                                        decoration: const InputDecoration(
                                            hintText: "Write your title",
                                            border: OutlineInputBorder()),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                        controller: _notebodyEditnController,
                                        maxLines: 4,
                                        decoration: const InputDecoration(
                                          hintText: "Write your note text",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      ElevatedButton(
                                          onPressed: () =>
                                              FirebaseNotesReposetoreis
                                                  .updateNote(NoteModel(
                                                      id: snapshot
                                                          .data![index].id,
                                                      title:
                                                          _titleEditingController
                                                              .text,
                                                      text:
                                                          _notebodyEditnController
                                                              .text)),
                                          child: const Text("Save Changes")),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                FirebaseNotesReposetoreis.deleteNote(
                                    snapshot.data![index]),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
