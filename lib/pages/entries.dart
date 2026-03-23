import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entry_database.dart';
import 'package:isar/isar.dart';
import '../models/entry.dart';



class EntriesPage extends StatefulWidget {
  const EntriesPage({super.key});
  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  final entryTitle = TextEditingController();
  final entryContent = TextEditingController();
  //dropdown for mood
  final List<Mood> moods = Mood.values;
  final entryDate = DateTime.now();
  //optional image path
  final entryImagePath = TextEditingController();

  //ACTIONS 

  void createEntry(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: entryTitle,
              decoration: const InputDecoration(hintText: 'Enter entry title...'),
            ),
            
              const SizedBox(height:10),
              TextField(
                controller: entryContent,
                decoration: const InputDecoration(hintText: 'Enter entry content...'),

              ),
          ],
        ),
        actions: [
          //note- didnt add async and await so it is instant and adds entry instantly without waiting.
          // ^ for the report, daylio is successfull because it does entry logging effortlessly and quick.
          MaterialButton(
            onPressed: () async{

              try{
                await context.read<EntryDB>().addEntry(
                  Entry()    
                  ..title = entryTitle.text
                  ..content = entryContent.text
                  ..mood = Mood.happy
                  ..date = DateTime.now()
                  ..imagePath = null
                );

                debugPrint("Entry SAVED to db message is from entries.dart");

                if (!mounted) return;
                Navigator.pop(context);

                // this likne is added to save the popup after creating entry 
                //Navigator.pop(context);

                entryTitle.clear();
                entryContent.clear();
                entryImagePath.clear();

              }catch (e){
                debugPrint("failed TO SAVE ENTRY *(MSG FROM entries.dart)");
              }
            },
            child: const Text('Submit'),
              
          )
        ]
      ),
    );
  }
  



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createEntry,
        child: const Icon(Icons.add),
      ),
      // body: const Center(
      //   child: Text('This is the Entries Page'),
        body: Consumer<EntryDB>(
          builder: (context, entryDB, child) {
            final entries = entryDB.currentEntries;

            if(entries.isEmpty){
              return const Center(
                child: Text('No entries yet. Click the + button to add one!'),
              );
            }

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];

                return ListTile(
                  title: Text(entry.title ?? 'No title'),
                  subtitle: Text(entry.content ?? 'No content'),
                );
              },
            );
          }
        )
    );
  }
}