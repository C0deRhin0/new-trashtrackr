import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signin.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Settings',
          style: TextStyle(color: AppColors.main),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildMenuItem(
            Icons.exit_to_app, 'Logout', SigninPage(),
          ),
        ],
      ),
    );
  }

  ListTile _buildMenuItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.icons,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.plateNumber,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
    );
  }
}