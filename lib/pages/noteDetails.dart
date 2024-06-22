import 'package:flutter/material.dart';
import 'package:notes/myDataBase.dart';

class NoteDetailsPage extends StatelessWidget {
  final int? id; // Make id optional
  final String title;
  final String content;
  final DateTime createdAt;

  const NoteDetailsPage({
    Key? key,
    this.id, // Declare id as optional
    required this.title,
    required this.content,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController contentController =
        TextEditingController(text: content);

    String formattedDate =
        "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    String characterCount = content.replaceAll(' ', '').length.toString();

    void saveNote() async {
      SqlDb database = SqlDb();
      if (id != null) {
        // Update existing note
        String sql = '''
          UPDATE note 
          SET title = '${titleController.text}', 
              content = '${contentController.text}'
          WHERE noteId = $id
        ''';
        await database.updateData(sql);
      } else {
        // Insert new note
        String sql = '''
          INSERT INTO note (title, content, iconColorIndex, date)
          VALUES ('${titleController.text}', '${contentController.text}', 0, '${createdAt.toIso8601String()}')
        ''';
        await database.insertData(sql);
      }

      Navigator.pop(context, true); // Pass true to indicate success
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed:
                        saveNote, // Call saveNote function on check button press
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
                  Text(
                    'Characters: $characterCount',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
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
