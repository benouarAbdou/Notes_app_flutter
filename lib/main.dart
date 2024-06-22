import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/Components/myNote.dart';
import 'package:notes/myDataBase.dart';
import 'package:notes/pages/noteDetails.dart';
import 'package:notes/provider/theme.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: themeProvider.isDarkMode
          ? const Color(0xFF0D1333) // Dark mode navigation bar color
          : Colors.white, // Light mode navigation bar color
    ));

    return MaterialApp(
      title: "My notes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blueAccent),
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        scaffoldBackgroundColor:
            themeProvider.isDarkMode ? const Color(0xFF0D1333) : Colors.white,
        cardColor: themeProvider.isDarkMode
            ? const Color(0xFF242947)
            : const Color(0xffEFF2F9),
        appBarTheme: AppBarTheme(
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          bodyMedium: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
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

  void deleteNote(BuildContext context, int id) async {
    SqlDb database = SqlDb();
    await database.deleteData('DELETE FROM note WHERE noteId = $id');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted')),
    );
    fetchNotesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    List<Widget> column1 = [];
    List<Widget> column2 = [];

    for (int i = 0; i < filteredNotes.length; i++) {
      var noteCard = ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
            child: Container(
              color: Theme.of(context).cardColor,
              child: filteredNotes[i],
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

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            navigateToNoteDetailsPage(null);
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
                  IconButton(
                    icon: Icon(themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
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
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
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
      fetchNotesFromDatabase();
    }
  }
}
