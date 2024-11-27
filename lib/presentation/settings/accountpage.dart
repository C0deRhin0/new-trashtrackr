import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';
import 'account settings pages/editpassword.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? userName;
  String? phoneNumber;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _createUserDocumentIfNotExists();
    _loadUserData();
  }

  Future<void> _createUserDocumentIfNotExists() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Create the document with default values
        await docRef.set({
          'name': 'New User', // Default name
          'phone': '', // Default phone number
          'profileImageUrl': '' // Default profile image
        });
      }
    }
  }

  /// Load user data from Firestore
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userName = doc['name'];
          phoneNumber = doc['phone'];
          profileImageUrl = doc['profileImageUrl'];
        });
      }
    }
  }

  /// Update user name in Firestore
  Future<void> _updateName(String name) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        await docRef.update({'name': name}); // Update name
      } catch (e) {
        if (e.toString().contains('NOT_FOUND')) {
          // Document doesn't exist, create it with the name
          await docRef.set({'name': name, 'phone': '', 'profileImageUrl': ''});
        } else {
          rethrow; // Rethrow other errors
        }
      }

      setState(() {
        userName = name;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Upload profile image to Firebase Storage
  Future<void> _uploadProfileImage() async {
    final user = _auth.currentUser;
    if (user != null) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final ref = _storage.ref().child('profile_images/${user.uid}.jpg');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        // Save the image URL to Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'profileImageUrl': url});

        setState(() {
          profileImageUrl = url;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile image updated successfully.'),
          backgroundColor: Colors.green,
        ));
      }
    }
  }

  /// Update phone number in Firestore
  Future<void> _updatePhoneNumber(String phone) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'phone': phone});
      setState(() {
        phoneNumber = phone;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Phone number updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }
  }

  /// Update email address in Firebase Authentication
  Future<void> _updateEmailAddress(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email address updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating email: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: GestureDetector(
              onTap: _uploadProfileImage,
              child: CircleAvatar(
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : AssetImage('assets/Profile.png') as ImageProvider,
              ),
            ),
            title: Text(userName ?? 'Name'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final name =
                    await _showEditDialog('Update Name', userName ?? '');
                if (name != null && name.isNotEmpty) {
                  _updateName(name);
                }
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'Account Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(_auth.currentUser?.email ?? 'Set Email Address'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final email = await _showEditDialog(
                  'Update Email Address',
                  _auth.currentUser?.email ?? '',
                );
                if (email != null && email.isNotEmpty) {
                  _updateEmailAddress(email);
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(phoneNumber ?? 'Set Phone Number'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final phone = await _showEditDialog(
                  'Update Phone Number',
                  phoneNumber ?? '',
                );
                if (phone != null && phone.isNotEmpty) {
                  _updatePhoneNumber(phone);
                }
              },
            ),
          ),
          ListTile(
            title: Text(
              'Edit Password',
              style: TextStyle(
                fontSize: 18.0,
                color: AppColors.settingsTextProper,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPassword(),
              ),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'Additional Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDeleteAccountOption(context),
        ],
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupOrSigninPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            title: 'Home',
          ),
        ),
      );
    }
  }

  Future<String?> _showEditDialog(String title, String initialValue) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter $title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountOption(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: AppColors.settingsTextProper,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
    );
  }

  Widget _buildDeleteAccountOption(BuildContext context) {
    return ListTile(
      title: Text(
        'Delete Account',
        style: TextStyle(
          fontSize: 18.0,
          color: AppColors.settingsTextProper,
        ),
      ),
      onTap: () => _confirmDeleteAccount(context),
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        await user.delete();
        await FirebaseAuth.instance.signOut();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupOrSigninPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user is currently signed in.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
