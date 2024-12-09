import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_trashtrackr/presentation/settings/notification%20settings%20pages/notificationreport.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification%20settings%20pages/notificationreport.dart';
import '../../core/config/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    as firebase_messaging;

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // State variables for toggling switches
  bool isAnalyticsEnabled = true; // Default value
  bool isTruckLocationAlertEnabled = true; // Default value

  @override
  void initState() {
    super.initState();
    _loadToggleStates();
    _configureFCM();
  }

  Future<void> _configureFCM() async {
    final messaging = firebase_messaging.FirebaseMessaging.instance;

    // Request permissions for notifications
    firebase_messaging.NotificationSettings settings =
        await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus ==
        firebase_messaging.AuthorizationStatus.authorized) {
      debugPrint('User granted permission for notifications');
    } else {
      debugPrint('User denied or did not respond to notification permissions');
    }

    // Get the FCM token
    final token = await messaging.getToken();
    if (token != null) {
      debugPrint('Successfully retrieved FCM token: $token');
    } else {
      debugPrint('Failed to retrieve FCM token');
    }

    // Save the FCM token to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Log the user's UID
        debugPrint('Saving FCM token for user: ${user.uid}');

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fcmToken': token,
        }, SetOptions(merge: true));
        debugPrint('FCM token saved successfully!');
      } catch (e) {
        debugPrint('Error saving FCM token: $e');
      }
    } else {
      debugPrint('No user is logged in, cannot save FCM token.');
    }

    // Listen for foreground messages
    firebase_messaging.FirebaseMessaging.onMessage
        .listen((firebase_messaging.RemoteMessage message) {
      debugPrint(
          'Received a message while in foreground: ${message.notification}');
    });
  }

  /// Load saved toggle states from SharedPreferences
  Future<void> _loadToggleStates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isAnalyticsEnabled =
            prefs.getBool('isAnalyticsEnabled') ?? true; // Default to true
        isTruckLocationAlertEnabled =
            prefs.getBool('isTruckLocationAlertEnabled') ?? true;
      });
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  /// Save a toggle state to SharedPreferences
  Future<void> _saveToggleState(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);

      // Save the toggle state to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {
            'notificationPreferences': {
              key: value,
            },
          },
          SetOptions(merge: true),
        );
      }
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  void _setupNotificationListeners() {
    // Foreground notifications
    firebase_messaging.FirebaseMessaging.onMessage
        .listen((firebase_messaging.RemoteMessage message) {
      if (message.notification != null) {
        debugPrint('Notification Title: ${message.notification!.title}');
        debugPrint('Notification Body: ${message.notification!.body}');
        // Show a dialog/snackbar or handle the notification UI
      }
    });

    // Background notifications
    firebase_messaging.FirebaseMessaging.onBackgroundMessage(
        _firebaseBackgroundHandler);

    // Notification opened (when the app is in terminated or background state)
    firebase_messaging.FirebaseMessaging.onMessageOpenedApp
        .listen((firebase_messaging.RemoteMessage message) {
      debugPrint('Notification was opened: ${message.notification}');
      // Navigate to a specific screen based on the notification data
    });
  }

// Background handler (must be a top-level function)
  Future<void> _firebaseBackgroundHandler(
      firebase_messaging.RemoteMessage message) async {
    debugPrint('Handling a background message: ${message.messageId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textOnboard_2,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                _buildCarouselItem(
                  title: 'Device Permissions',
                  description:
                      'Grant the app permission to access notifications and location services.',
                ),
                _buildCarouselItem(
                  title: 'Location Sharing',
                  description:
                      'Enable location sharing to get real-time truck alerts.',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Notification Section
            _buildNotificationSettingSection(),
            const SizedBox(height: 20.0),
            // Notification Report Compilation Button
            ListTile(
              leading: const Icon(Icons.notifications, size: 30.0),
              title: const Text("Notification Reports"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationCompilationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each carousel item
  Widget _buildCarouselItem(
      {required String title, required String description}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: AppColors.carouselBox,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  // Helper method to build the notification settings section
  Widget _buildNotificationSettingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        const Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        _buildToggleItem(
          title: 'Analytics',
          icon: const Icon(Icons.analytics, size: 30.0),
          value: isAnalyticsEnabled,
          onChanged: (value) {
            setState(() {
              isAnalyticsEnabled = value;
            });
            _saveToggleState('isAnalyticsEnabled', value); // Save state
          },
        ),
        _buildToggleItem(
          title: 'Truck Location Alert',
          icon: const Icon(Icons.location_on, size: 30.0),
          value: isTruckLocationAlertEnabled,
          onChanged: (value) {
            setState(() {
              isTruckLocationAlertEnabled = value;
            });
            _saveToggleState(
                'isTruckLocationAlertEnabled', value); // Save state
          },
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  // Helper method to build each toggle item with a switch
  Widget _buildToggleItem({
    required String title,
    required Widget icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
