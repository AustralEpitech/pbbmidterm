import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Story {
  final String title;
  final String description;
  final String image;

  const Story({required this.title, required this.description, required this.image});

  Map<String, Object?> toMap() {
    return {
      'title': title, 'description': description, 'image': image
    };
  }

  @override
  String toString() {
    return 'Story{title: $title, description: $description, image: $image}';
  }
}

Future<Database> opendb() async {
  return openDatabase(
    join(await getDatabasesPath(), 'stories.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE stories(id INTEGER PRIMARY KEY, title VARCHAR(255), description TEXT, image VARCHAR(1024))',
      );
    },
    version: 1,
  );
}

Future<void> insertStory(Story story) async {
  final db = await opendb();

  await db.insert('stories', story.toMap());
}

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryBase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'StoryBase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  List<Widget> _stories = [];

  void _addEntry() async {
    setState(() {
      var s = Story(title: 'title', description: '', image: '');

      _stories.add(_container(s.title));
      insertStory(s);
    });
  }

  Container _container(String title) {
    return Container(
          height: 64,
          child: Text(title),
    );
  }

  void _getStories() {
    opendb().then((db) {
      db.query('stories').then((List<Map<String, dynamic>> stories) {

        for (var s in stories) {
          _stories.add(_container(s['title']));
        }
      });
    });
  }

  void initState() {
    _getStories();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: _stories,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        tooltip: 'add',
        child: const Icon(Icons.add),
        ),
    );
  }
}
