import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';

// Bottom Drawer Implementation
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // The Settings List in the Bottom Drawer
              SettingsSection(
                title: 'Personal Settings',
                items: [
                  SettingsItem(icon: Icons.account_circle, title: 'Account'),
                  SettingsItem(icon: Icons.location_on, title: 'Location'),
                  SettingsItem(
                      icon: Icons.notifications, title: 'Notification'),
                ],
              ),
              SettingsSection(
                title: 'Additional Settings',
                items: [
                  SettingsItem(icon: Icons.analytics, title: 'Analytics'),
                  SettingsItem(icon: Icons.privacy_tip, title: 'Privacy'),
                  SettingsItem(icon: Icons.support, title: 'Support'),
                  SettingsItem(icon: Icons.logout, title: 'Sign Out'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Reusable Settings Section
class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(items[index].icon),
                iconColor: AppColors.icons,
                title: Text(items[index].title),
                textColor: AppColors.mainpageText,
                onTap: () {
                  // Handle item tap
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// Settings Item Model
class SettingsItem {
  final IconData icon;
  final String title;

  SettingsItem({required this.icon, required this.title});
}
