import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import '../../core/config/theme/app_colors.dart';

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
    _loadToggleStates(); // Load saved states when the widget is initialized
  }

  /// Load saved toggle states from SharedPreferences
  Future<void> _loadToggleStates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isAnalyticsEnabled =
            prefs.getBool('isAnalyticsEnabled') ?? true; // Default to true
        isTruckLocationAlertEnabled =
            prefs.getBool('isTruckLocationAlertEnabled') ??
                true; // Default to true
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
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
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
            SizedBox(height: 20.0),
            // Notification Section
            _buildNotificationSettingSection(),
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
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: AppColors.carouselBox,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(fontSize: 14.0),
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
        SizedBox(height: 20.0),
        Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        _buildToggleItem(
          title: 'Analytics',
          icon: Icon(Icons.analytics, size: 30.0),
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
          icon: Icon(Icons.location_on, size: 30.0),
          value: isTruckLocationAlertEnabled,
          onChanged: (value) {
            setState(() {
              isTruckLocationAlertEnabled = value;
            });
            _saveToggleState(
                'isTruckLocationAlertEnabled', value); // Save state
          },
        ),
        SizedBox(height: 10.0),
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
