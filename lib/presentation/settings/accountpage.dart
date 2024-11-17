import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import 'account settings pages/editemail.dart';
import 'account settings pages/editphonenum.dart';
import 'account settings pages/editpassword.dart';
import 'account settings pages/profile.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  title: 'Home',
                ),
              ),
            );
          },
        ),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          title: Text('Name'),
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
        _buildAccountOption(context, 'Edit Email Address', EditEmail()),
        _buildAccountOption(context, 'Edit Phone Number', EditPhoneNum()),
        _buildAccountOption(context, 'Edit Password', EditPassword()),
        const Divider(),
        const ListTile(
          title: Text(
            'Additional Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildAdditionalAccountOption('Delete Account'),
      ]),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: AppColors.main,
      ),
    ),
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
      });
}

Widget _buildAdditionalAccountOption(String title) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        color: AppColors.settingsTextProper,
      ),
    ),
  );
}
