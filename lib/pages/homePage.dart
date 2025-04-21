import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:notes/Components/myNote.dart';
import 'package:notes/controllers/NoteController.dart';
import 'package:notes/controllers/ThemeController.dart';
import 'package:notes/pages/noteDetails.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController noteController = Get.find();
    final ThemeController themeController = Get.find();
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Get.to(() => const NoteDetailsPage())?.then((result) {
              if (result == true) {
                noteController.fetchNotes();
              }
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My notes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => IconButton(
                        icon: Icon(themeController.isDarkMode.value
                            ? Icons.light_mode
                            : Icons.dark_mode),
                        onPressed: themeController.toggleTheme,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Search note...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  onChanged: (value) =>
                      noteController.searchQuery.value = value,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final notes = noteController.filteredNotes;
                List<Widget> column1 = [];
                List<Widget> column2 = [];

                for (int i = 0; i < notes.length; i++) {
                  final note = notes[i];
                  var noteCard = ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 1,
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              noteController.deleteNote(note.id);
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => NoteDetailsPage(note: note))
                              ?.then((result) {
                            if (result == true) {
                              noteController.fetchNotes();
                            }
                          });
                        },
                        child: Container(
                          color: Theme.of(context).cardColor,
                          child: MyNote(
                            id: note.id,
                            title: note.title,
                            content: note.content,
                            date: note.date,
                          ),
                        ),
                      ),
                    ),
                  );

                  if (i % 2 == 0) {
                    column1.add(noteCard);
                    column1.add(const SizedBox(height: 10));
                  } else {
                    column2.add(noteCard);
                    column2.add(const SizedBox(height: 10));
                  }
                }

                return SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: column1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: column2,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
