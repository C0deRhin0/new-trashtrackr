import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../settings/accountpage.dart';

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isOldPasswordHidden = true;
  bool _isNewPasswordHidden = true;

  // Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to verify old password and update the new password
  Future<void> _updatePassword(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Reauthenticate with the old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      try {
        await user.reauthenticateWithCredential(credential);

        // If reauthentication succeeds, update the password
        await user.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password updated successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountPage()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'wrong-password') {
          errorMessage = 'The old password is incorrect.';
        } else {
          errorMessage = 'Failed to update password: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
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
            // Old Password Field
            TextField(
              controller: _oldPasswordController,
              obscureText: _isOldPasswordHidden,
              decoration: InputDecoration(
                labelText: "Old Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordHidden = !_isOldPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // New Password Field
            TextField(
              controller: _newPasswordController,
              obscureText: _isNewPasswordHidden,
              decoration: InputDecoration(
                labelText: "New Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordHidden = !_isNewPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Update Button
            ElevatedButton(
              onPressed: () => _updatePassword(context),
              child: Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}
