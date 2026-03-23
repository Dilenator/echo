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




class EntryDB extends ChangeNotifier {
  static late Isar isar;

  List<Entry> currentEntries = [];

  //initialise isar db
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [EntrySchema],
      directory: dir.path,
    );
  }

  //create
  Future<void> addEntry(Entry entry) async {
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    await fetchEntries();

    
  }


  // read all
  Future<void> fetchEntries() async {
    //sort by date? 
    //future add sort by mood etc, or other filters.
    final entriesSortedByDate = await isar.entrys.where().sortByDateDesc().findAll();

    currentEntries.clear();

    currentEntries.addAll(entriesSortedByDate);

    for(var entry in currentEntries){
      debugPrint(

        // Console check to see if db is working=
          'ALLLLLLLLLLLLLLLLLLLEEEEEEEEEERRRRRRRRRRRRTTTTTTTT'
          'Title: ${entry.title}, Content: ${entry.content}, Mood: ${entry.mood}, Date: ${entry.date}',

      );
    }


    notifyListeners();  

  }
  // read one (for example when i am clicking on a specific entry)
  static Future<Entry?> getEntryById(Id id) async {
    return await isar.entrys.get(id);
  }

  //update
  Future<void> updateEntry(Entry entry) async {


    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    await fetchEntries();
  }

  //delete a note
  Future<void> deleteEntry(Id id) async {
    await isar.writeTxn(() async {

      await isar.entrys.delete(id);
    });

    await fetchEntries();
  }


}