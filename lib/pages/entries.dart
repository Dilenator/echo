import 'package:flutter/material.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Entry page
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('This is the Entries Page'),
      ),
    );
  }
}
