import 'package:flutter/material.dart';
import 'package:isar/isar.dart';


part 'entry.g.dart';


enum Mood{
  happy,
  okay,
  calm,
  sad,
  angry,
}

String moodEmoji(Mood mood) {
  switch (mood) {
    case Mood.happy:
      return '😊';
    case Mood.okay:
      return '😐';
    case Mood.calm:
      return '😌';
    case Mood.sad:
      return '😢';
    case Mood.angry:
      return '😡';


  }
}


@Collection() 
class Entry{
  Id id = Isar.autoIncrement;
  String? title;
  String? content;
  @enumerated
  late Mood mood; // Emoji based on Unicode text??  ?
  late DateTime date; //required
  //image 
  String? imagePath; // Store the path to the image in the device's storage
  // Image image; will not work as isar does not support storing images directly.
  
  //reqiuire all input fields to be inputted.
  // Potentially i may make content and image optional later for faster logging.
  //Entry({required this.title, required this.content, required this.date, required this.mood, required this.imagePath});
}