import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import '../../core/config/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({super.key});

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
                      'Lorem ipsum odor amet, consectetuer adipiscing elit.',
                ),
                _buildCarouselItem(
                  title: 'Location Sharing',
                  description:
                      'Lorem ipsum odor amet, consectetuer adipiscing elit.',
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // Location Sharing Section
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

  // Helper method to build the location sharing section
  Widget _buildNotificationSettingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        _buildLocationItem(
          title: 'Analytics',
          icon: Icon(Icons.analytics, size: 30.0),
        ),
        _buildLocationItem(
          title: 'Truck Location Alert',
          icon: Icon(Icons.location_on, size: 30.0),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  // Helper method to build each location item with a switch
  Widget _buildLocationItem({required String title, required Widget icon}) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: Switch(
        value: true, // Static value, doesn't change state
        onChanged: (value) {},
      ),
    );
  }
}
