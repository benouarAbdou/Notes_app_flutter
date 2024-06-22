import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/Components/myNote.dart';
import 'package:notes/myDataBase.dart';
import 'package:notes/pages/noteDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MyNote> notes = [];
  List<MyNote> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNotesFromDatabase();
    searchController.addListener(() {
      filterNotes();
    });
  }

  void fetchNotesFromDatabase() async {
    SqlDb database = SqlDb();
    List<Map<String, dynamic>> data =
        await database.readData('SELECT * FROM note');
    List<MyNote> fetchedNotes = [];

    for (var item in data) {
      MyNote note = MyNote(
        id: item["noteId"],
        title: item['title'],
        content: item['content'],
        color: _mapColorFromIndex(item['iconColorIndex']),
        date: DateTime.parse(item["date"]),
      );
      fetchedNotes.add(note);
    }

    setState(() {
      notes = fetchedNotes;
      filteredNotes = fetchedNotes;
    });
  }

  void filterNotes() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  Color _mapColorFromIndex(int colorIndex) {
    switch (colorIndex) {
      case 0:
        return Colors.blueAccent;
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.greenAccent;
      case 3:
        return Colors.yellowAccent;
      case 4:
        return Colors.purpleAccent;
      case 5:
        return Colors.orangeAccent;
      default:
        return Colors.blueAccent;
    }
  }

  void deleteNote(BuildContext context, int id) async {
    SqlDb database = SqlDb();
    await database.deleteData('DELETE FROM note WHERE noteId = $id');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted')),
    );
    fetchNotesFromDatabase(); // Refresh notes after deletion
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> column1 = [];
    List<Widget> column2 = [];

    for (int i = 0; i < filteredNotes.length; i++) {
      if (i % 2 == 0) {
        column1.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Slidable(
              endActionPane: ActionPane(
                extentRatio: 1,
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      deleteNote(context, filteredNotes[i].id);
                    },
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  navigateToNoteDetailsPage(filteredNotes[i]);
                },
                child: filteredNotes[i],
              ),
            ),
          ),
        );
        column1.add(
          const SizedBox(
            height: 10,
          ),
        );
      } else {
        column2.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Slidable(
              endActionPane: ActionPane(
                extentRatio: 1,
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      deleteNote(context, filteredNotes[i].id);
                    },
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  navigateToNoteDetailsPage(filteredNotes[i]);
                },
                child: filteredNotes[i],
              ),
            ),
          ),
        );
        column2.add(
          const SizedBox(
            height: 10,
          ),
        );
      }
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          navigateToNoteDetailsPage(null); // Passing null means add new note
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "My notes",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2F9),
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
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: column1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: column2,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToNoteDetailsPage(MyNote? note) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailsPage(
          id: note?.id,
          title: note?.title ?? "",
          content: note?.content ?? "",
          createdAt: note?.date ?? DateTime.now(),
        ),
      ),
    );

    if (result) {
      fetchNotesFromDatabase(); // Refresh notes after returning from details page
    }
  }
}
