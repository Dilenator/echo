import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'entry.dart';


// this file is for opening the isar db, and providing methods like:
// add entry
// get entry
// delete entry
// update entry.

//CRUD

// CREATE <- save to db
// READ <- get from db
// UPDATE
// DELETE




class EntryDB extends ChangeNotifier { //notify UI when data changes. auto updates UI when notifyListeners is called.
  static late Isar isar;

  List<Entry> currentEntries = [];

  //initialise isar db
  static Future<void> init() async { // async means we wait for db to open before doing anytinng else
    final dir = await getApplicationDocumentsDirectory();
    //wait for isar for db ''await''
    isar = await Isar.open(
      [EntrySchema],
      directory: dir.path,
    );
  }

  //create entry
  Future<void> addEntry(Entry entry) async {

    final stopwatch = Stopwatch()..start();

    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    await fetchEntries();

    stopwatch.stop();
    debugPrint('Time taken to add entry: ${stopwatch.elapsedMilliseconds} ms');
  }


  // read all
  Future<void> fetchEntries() async {


    final stopwatch = Stopwatch()..start();

    //sort by date? 
    //future add sort by mood etc, or other filters.
    final entriesSortedByDate = await isar.entrys.where().sortByDateDesc().findAll();

    currentEntries.clear();

    currentEntries.addAll(entriesSortedByDate);



    stopwatch.stop();
    debugPrint('Time taken to fetch entries: ${stopwatch.elapsedMilliseconds} ms');

    notifyListeners();  

  }
  // read one (for example when i am clicking on a specific entry)
  static Future<Entry?> getEntryById(Id id) async {
    return await isar.entrys.get(id);
  }

  //update
  Future<void> updateEntry(Entry entry) async {



    final stopwatch = Stopwatch()..start();

    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    stopwatch.stop();
    debugPrint('Time taken to update entry: ${stopwatch.elapsedMilliseconds} ms');

    await fetchEntries();
  }

  //delete a entry
  Future<void> deleteEntry(Id id) async {

    final stopwatch = Stopwatch()..start();
    await isar.writeTxn(() async {

      await isar.entrys.delete(id);
    });
    
    stopwatch.stop();
    debugPrint('Time taken to delete entry: ${stopwatch.elapsedMilliseconds} ms');

    await fetchEntries();
  }


}