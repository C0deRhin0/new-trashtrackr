import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import '../../core/config/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSettings extends StatefulWidget {
  const LocationSettings({super.key});

  @override
  _LocationSettingsState createState() => _LocationSettingsState();
}

class _LocationSettingsState extends State<LocationSettings> {
  // State variables for toggling switches
  bool isNameSharingEnabled = true; // Default value
  bool isTruckLocationSharingEnabled = true; // Default value

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
        isNameSharingEnabled =
            prefs.getBool('isNameSharingEnabled') ?? true; // Default to true
        isTruckLocationSharingEnabled =
            prefs.getBool('isTruckLocationSharingEnabled') ??
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
        title: Text('Location'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            SizedBox(height: 20.0),
            // Location Sharing Section
            _buildLocationSharingSection(),
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

  // Helper method to build the location sharing section
  Widget _buildLocationSharingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text(
          'Your Location Sharing',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        _buildToggleItem(
          title: 'Name Sharing',
          icon: SvgPicture.asset(
            'assets/vectors/logos/logo.svg', // SVG image loaded using flutter_svg
            width: 30.0,
            height: 30.0,
          ),
          value: isNameSharingEnabled,
          onChanged: (value) {
            setState(() {
              isNameSharingEnabled = value;
            });
            _saveToggleState('isNameSharingEnabled', value); // Save state
          },
        ),
        SizedBox(height: 10.0),
        Text(
          'Truck Location Sharing',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        _buildToggleItem(
          title: 'Truck Location',
          icon: Icon(Icons.local_shipping, size: 30.0),
          value: isTruckLocationSharingEnabled,
          onChanged: (value) {
            setState(() {
              isTruckLocationSharingEnabled = value;
            });
            _saveToggleState(
                'isTruckLocationSharingEnabled', value); // Save state
          },
        ),
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
