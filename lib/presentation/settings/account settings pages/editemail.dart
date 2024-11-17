import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../settings/accountpage.dart';

class EditEmail extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _updateEmail(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.currentUser?.updateEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email updated successfully")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AccountPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update email: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Email Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AccountPage()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "New Email"),
            ),
            ElevatedButton(
              onPressed: () => _updateEmail(context),
              child: Text("Update Email"),
            ),
          ],
        ),
      ),
    );
  }
}
