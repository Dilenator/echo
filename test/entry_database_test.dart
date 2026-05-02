

import 'dart:io'; //for temp Isar db

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:echo/models/entry.dart';
import 'package:echo/models/entry_database.dart';

void main() {
  late EntryDB db;
  late Directory dir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp();
    EntryDB.isar = await Isar.open([EntrySchema], directory: dir.path);
    db = EntryDB();
  });

  tearDown(() async {
    await EntryDB.isar.close(deleteFromDisk: true);
    await dir.delete(recursive: true);
  });


//CRUD Test

  test('CRUD works', () async {
    //add entry 
    final entry = Entry()
      ..title = 'Test'
      ..content = 'test entry'
      ..imagePath = null
      ..mood = Mood.happy
      ..date = DateTime.now();


    await db.addEntry(entry);
    expect(db.currentEntries.length, 1);

    //update entry

    final saved = db.currentEntries.first;
    saved.title = 'Updated Title';
    await db.updateEntry(saved);

    expect(db.currentEntries.first.title, 'Updated Title');
    expect(db.currentEntries.first.content, 'test entry');

    //Delete 

    await db.deleteEntry(saved.id);
    expect(db.currentEntries.isEmpty, true);
  });
}