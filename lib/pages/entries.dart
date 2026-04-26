import 'dart:io'; //forloading image from phone storage
import 'package:flutter/material.dart'; //flutter UI library
import 'package:provider/provider.dart'; // provider for state management (notifyListeners)

import '../models/entry.dart';//entry model and moodemoji
import '../models/entry_database.dart'; //db
import 'add_entry.dart'; //add entries page



class EntriesPage extends StatefulWidget {
  const EntriesPage({super.key});
  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  final _blue = const Color(0xFF4A6FA5); // final so it doesnt change after intialisation
  final _cream = const Color(0xFFF5F5DC);

  //date for entry with day, date, month, year
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _viewEntry(BuildContext context, Entry entry) {
    showDialog(
      context: context,
      //return popup widget to display
      builder: (context) => AlertDialog(
        //title
        title: Text(_formatDate(entry.date)),
        
        //content of popup

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //mood emoji
            Text('Mood: ${moodEmoji(entry.mood)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            //what happened
            Text('What happened: ${entry.title ?? 'Not provided'}'),
            const SizedBox(height: 8),

            //why it happened
            Text('Why it happened: ${entry.content ?? 'Not provided'}'),
            const SizedBox(height: 8),

            //image
            if (entry.imagePath != null)
              Image.file(File(entry.imagePath!), height: 100, fit: BoxFit.cover),

          ],
        ),

        //close button of popup
        // actions: [
        //   TextButton(
        //     onPressed: () => Navigator.pop(context),
        //     child: const Text('Close'),
        //   ),
        // ],

        actions: [
          //delete button to delete entry
          TextButton(
            onPressed: () async {
              await context.read<EntryDB>().deleteEntry(entry.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ]


      )
    );
  }


  //// EDITING ENTRY
  void _editEntry(BuildContext context, Entry entry) {
    // Navigate to the AddEntryPage with the existing entry data for editing
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEntryPage(entry: entry)
      ),
    );
    
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: _cream,


    //// ADD ENTRY BUTTON
      floatingActionButton: FloatingActionButton(
      onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddEntryPage()),
    );
    },        
    child: const Icon(Icons.add),

    //// ADD ENTRY BUTTON END 
    


      ),
      // body: const Center(
      //   child: Text('This is the Entries Page'),
        body: SafeArea(
          child: Consumer<EntryDB>( //updates DB when changes are made
            builder: (context, entryDB, child) {
              final entries = entryDB.currentEntries;
              //if no entries, show empty message
              if(entries.isEmpty){
              return const Center(
                child: Text('No entries yet. Click the + button to add one!'),
                
              );

            }

            //IF NOT EMPTY
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //ENTRIES HEADER
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Your Entries',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                 // list of entry cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: entries.length,
                    itemBuilder: (context, index) => _buildCard(entries[index]),
                  ),
                )

              ],
            );
      },  
        )
    ),
    );
  }

  Widget _buildCard(Entry entry){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //DATE of card
          Text(
            _formatDate(entry.date),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.bold
            ),
          ),          
          //
          const SizedBox(height: 12),
          
          Row(
            children:[
              
              //MOOD EMOJI
              Text(
                moodEmoji(entry.mood), style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
              
              //IMG
              if (entry.imagePath != null)
                Image.file(
                  File(entry.imagePath!),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              //push button to right
              const Spacer(),
              //VIEW ENTRY BTN
              ElevatedButton(
                onPressed: () => _viewEntry(context, entry),
                child: const Text('View'),
              ),
              //
              const SizedBox(width: 8),
              //EDIT ENTRY BTN
              ElevatedButton(
                onPressed: () => _editEntry(context, entry),
                child: const Text('Edit'),
              ),
              //

            ]
          )

          
        ]
          
      )

    );
  }

}
