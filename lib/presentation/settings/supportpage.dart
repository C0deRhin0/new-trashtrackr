import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/concern.dart';
import '../services/concern_service.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final ConcernService _concernService = ConcernService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name'),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Email'),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Phone Number'),
            SizedBox(height: 8),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Concern'),
            SizedBox(height: 8),
            TextField(
              controller: _concernController,
              maxLines: 5,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitConcern,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.support_agent,
          color: Colors.black,
        ),
      ),
    );
  }

  void _submitConcern() {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _concernController.text.isNotEmpty) {
      final concern = Concern(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        concern: _concernController.text,
        createdOn: Timestamp.now(),
      );

      _concernService.addConcern(concern).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Concern submitted successfully!")),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit concern: $error")),
        );
      });

      _nameController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _concernController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out all fields.")),
      );
    }
  }
}
