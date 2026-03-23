import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/entries.dart';
import 'models/entry_database.dart';
import 'models/entry.dart';
import 'package:provider/provider.dart';

void main() async {
  //test
  //print("hii");
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //calling on initialise method in entry db

  final entryDB = EntryDB();
  print(entryDB.currentEntries.length);
  
  await EntryDB.init();



// //// TESTING CRUD OPERATIONS

//   final testEntry = Entry()
//   ..title = 'Test title'
//   ..content = 'Test content'
//   ..mood = Mood.happy
//   ..date = DateTime.now()
//   ..imagePath = null;

// await entryDB.addEntry(testEntry);
// print('Created entry');

// await entryDB.fetchEntries();
// print('Read entries: ${entryDB.currentEntries.length}');

// final firstEntry = entryDB.currentEntries.first;
// firstEntry.title = 'Updated title';
// await entryDB.updateEntry(firstEntry);
// print('Updated entry');

// await entryDB.fetchEntries();
// print('Updated title: ${entryDB.currentEntries.first.title}');

// await entryDB.deleteEntry(firstEntry.id);
// print('Deleted entry');

// await entryDB.fetchEntries();
// print('Entries after delete: ${entryDB.currentEntries.length}');


  runApp(
    ChangeNotifierProvider(
      create: (_) => entryDB,
      child: const MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EntriesPage(),
    );
    }
    }