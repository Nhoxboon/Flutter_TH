import 'package:flutter/material.dart';

class PopMenuListScreen extends StatelessWidget {
  const PopMenuListScreen({super.key});

  // Sample data for the contact list
  final List<Map<String, String>> contacts = const [
    {'name': 'Liam', 'initial': 'L'},
    {'name': 'Noah', 'initial': 'N'},
    {'name': 'Oliver', 'initial': 'O'},
    {'name': 'William', 'initial': 'W'},
    {'name': 'Elijah', 'initial': 'E'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pop Menu with List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: Text(
                contact['initial']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            title: Text(
              contact['name']!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              // Handle contact selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected ${contact['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
