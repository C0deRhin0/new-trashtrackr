import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 151, 246, 174),
        title: Text('Settings'), // Title of the app bar
      ),
      body: Stack(
        children: [
          // Background content (like the map in the image)
          Container(
            height: 300,
            color: AppColors.background, // Placeholder for the map
            child: Center(
                child: Text('Map goes here',
                    style: TextStyle(color: Colors.white))),
          ),
          // Bottom sheet with settings
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    _buildSectionTitle('Personal Settings'),
                    _settingsMenuItem(Icons.account_circle, 'Account'),
                    _settingsMenuItem(Icons.location_on, 'Location'),
                    _settingsMenuItem(Icons.notifications, 'Notification'),
                    Divider(), // Divider between sections
                    _buildSectionTitle('Additional Settings'),
                    _settingsMenuItem(Icons.analytics, 'Analytics'),
                    _settingsMenuItem(Icons.lock, 'Privacy'),
                    _settingsMenuItem(Icons.support, 'Support'),
                    _settingsMenuItem(Icons.logout, 'Sign Out'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper method to create a menu item with only an icon and title
  ListTile _settingsMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Handle menu item tap here, e.g., navigate to another page
      },
    );
  }

  // Helper to build section titles like 'Personal Settings' and 'Additional Settings'
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
}
