import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signin.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';
import 'package:new_trashtrackr/presentation/settings/accountpage.dart';
import 'package:new_trashtrackr/presentation/settings/notificationsettings.dart';
import 'package:new_trashtrackr/presentation/settings/locationsettings.dart';
import 'package:new_trashtrackr/presentation/settings/analyticspage.dart';
import 'package:new_trashtrackr/presentation/settings/supportpage.dart';
import 'package:new_trashtrackr/presentation/settings/privacy.dart';

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
          _buildSectionTitle('Personal Settings'),
          _buildMenuItem(
              Icons.person_2_outlined, 'Account Settings', AccountPage()),
          _buildMenuItem(Icons.notifications, 'Notification Settings',
              NotificationSettings()),
          _buildMenuItem(Icons.location_on_outlined, 'Location Settings',
              LocationSettings()),
          _buildSectionTitle('Additional Settings'),
          _buildMenuItem(
              Icons.analytics_outlined, 'Analytics Settings', AnalyticsPage()),
          _buildMenuItem(
              Icons.privacy_tip_outlined, 'Privacy Settings', PrivacyPage()),
          _buildMenuItem(
              Icons.support_agent_outlined, 'Support Settings', SupportPage()),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: AppColors.icons,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                color: AppColors.plateNumber,
              ),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Padding _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.settingsTextProper,
        ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupOrSigninPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
