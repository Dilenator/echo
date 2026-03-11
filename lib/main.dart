import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/entries.dart';
import 'models/entry_database.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //calling on initialise method in entry db
  await EntryDB.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => EntryDB(),
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