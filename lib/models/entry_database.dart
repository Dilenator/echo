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




class EntryDB {
  static late Isar isar;

  static List<Entry> currentEntries = [];

  //initialise isar db
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [EntrySchema],
      directory: dir.path,
    );
  }

  //create
  static Future<void> addEntry(Entry entry) async {
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });

    await fetchEntries();

    
  }


  // read all
  static Future<void> fetchEntries() async {
    //sort by date? 
    //future add sort by mood etc, or other filters.
    final entriesSortedByDate = await isar.entrys.where().sortByDateDesc().findAll();

    currentEntries.clear();
    currentEntries.addAll(entriesSortedByDate);
  }



}