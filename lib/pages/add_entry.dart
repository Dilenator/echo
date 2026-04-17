import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/entry.dart';
import '../models/entry_database.dart';


class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}


//_ is for basically that means the class is private. 
class _AddEntryPageState extends State<AddEntryPage>{
  final _whatHappened =  TextEditingController();
  final _whyItHappened = TextEditingController();
  Mood _selectedMood = Mood.happy;
  DateTime _selectedDate = DateTime.now();
  String? _imagePath;

  // UI COLOUR
  final _blue = const Color(0xFF4A6FA5);
  final _cream = const Color(0xFFF5F5DC);

  final _moods = [
    (Mood.happy, '😊'),
    (Mood.okay, '😐'),
    (Mood.calm, '😌'),
    (Mood.sad, '😢'),
    (Mood.angry, '😡'),
  ];

  Future<void> _pickImage() async{
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      setState(() => _imagePath = pickedImage.path);
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: _selectedDate, //set default to current date  
      firstDate: DateTime(2000), // earliest date is 2000.
      lastDate: _selectedDate //t he max is set to the current date, so you cant make future entries
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _saveEntry() async {
    final newEntry = Entry();
      newEntry.title = _whatHappened.text;
      newEntry.content = _whyItHappened.text;
      newEntry.mood = _selectedMood;
      newEntry.date = _selectedDate;
      newEntry.imagePath = _imagePath;

    await context.read<EntryDB>().addEntry(newEntry);

    if (!mounted) return;
    Navigator.pop(context);

  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _whatHappened.dispose();
    _whyItHappened.dispose();
    super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Add New Entry',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 16),
                
                // selecting mood of 
                const Text(
                  "How are you? feeling today?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _moods.map((pair) {
                      final mood = pair.$1;
                      final emoji = pair.$2;
                      final selected = _selectedMood == mood;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedMood = mood),
                        child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: selected
                            ? Border.all(color: Colors.yellow, width: 3) : null,
                        ),
                        child: Center(
                          child: Text(emoji, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                
                // What happned box
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What happened? (optional)',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _whatHappened,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),


                ]
              )
            ),

          ),
        ),
      ),
    ); 
  }


}