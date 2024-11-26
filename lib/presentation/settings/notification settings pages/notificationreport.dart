import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';

class NotificationCompilationPage extends StatelessWidget {
  // Mock notifications
  final List<Map<String, String>> notifications = [
    {
      "title": "System Update",
      "description": "Your app has been updated to the latest version.",
      "time": "10 mins ago"
    },
    {
      "title": "Reminder",
      "description": "Don't forget to check your weekly reports.",
      "time": "1 hour ago"
    },
    {
      "title": "Truck Update",
      "description": "Truck #123 has completed its route.",
      "time": "3 hours ago"
    },
    {
      "title": "Welcome!",
      "description": "Thanks for joining our platform!",
      "time": "Yesterday"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(
            title: notification["title"] ?? "",
            description: notification["description"] ?? "",
            time: notification["time"] ?? "",
            backgroundColor: AppColors.iconSecondary,
            textColor: AppColors.textOnboard_2,
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required Color backgroundColor,
    required Color textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.main,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationCompilationPage(),
  ));
}
