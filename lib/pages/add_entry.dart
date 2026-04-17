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
                ]
              )
            ),

          ),
        ),
      ),
    ); 
  }


}