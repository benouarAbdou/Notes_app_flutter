import 'package:flutter/material.dart';
import 'package:notes/Components/myNote.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<MyNote> notes = [
    const MyNote(
      title: "What is Lorem Ipsum? a reader will be distracted by t",
      content:
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using",
      color: Colors.blueAccent,
    ),
    const MyNote(
      title: "What is Lorem Ipsum?",
      content:
          "It is a long established fact that a reade content of a page when looking at its layout. The point of using Lorem tters, as opposed to using",
      color: Colors.redAccent,
    ),
    const MyNote(
      title: "What is Lorem Ipsum?",
      content: "Content 3",
      color: Colors.greenAccent,
    ),
    const MyNote(
      title: "What is Lorem Ipsum?",
      content: "Content 4",
      color: Colors.yellowAccent,
    ),
    const MyNote(
      title: "What is Lorem Ipsum?",
      content: "Content 5",
      color: Colors.purpleAccent,
    ),
    const MyNote(
      title: "What is Lorem Ipsum?",
      content: "Content 6",
      color: Colors.orangeAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> column1 = [];
    List<Widget> column2 = [];

    for (int i = 0; i < notes.length; i++) {
      if (i % 2 == 0) {
        column1.add(notes[i]);
      } else {
        column2.add(notes[i]);
      }
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {},
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
                child: const TextField(
                  decoration: InputDecoration(
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
                      width: 20,
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
}
