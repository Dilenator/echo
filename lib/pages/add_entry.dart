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
    if(pickedImage != null){
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: const Center(child: Text('Add Entry'),
      ),
    );

  }
}
