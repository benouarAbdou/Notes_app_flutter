import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controllers/NoteController.dart';
import 'package:notes/models/note.dart';

class NoteDetailsPage extends StatelessWidget {
  final Note? note;

  const NoteDetailsPage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    final NoteController noteController = Get.find();
    final TextEditingController titleController =
        TextEditingController(text: note?.title ?? '');
    final TextEditingController contentController =
        TextEditingController(text: note?.content ?? '');
    final createdAt = note?.date ?? DateTime.now();

    String formattedDate =
        "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    final characterCount =
        contentController.text.replaceAll(' ', '').length.obs;

    contentController.addListener(() {
      characterCount.value = contentController.text.replaceAll(' ', '').length;
    });

    void saveNote() {
      noteController.addOrUpdateNote(
        id: note?.id,
        title: titleController.text,
        content: contentController.text,
        date: createdAt,
      );
      Get.back(result: true);
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.back(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: saveNote,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '|',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  Obx(() => Text(
                        'Characters: ${characterCount.value}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: contentController,
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
