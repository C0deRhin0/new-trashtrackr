import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:new_trashtrackr/presentation/home/pages/settings.dart'
    as local_settings;

const outlinedColor = AppColors.background;
const iconBackgroundColor = AppColors.background;
final settingIconRounded = SymbolsGet.get('settings', SymbolStyle.rounded);
Icon settingIcon = Icon(settingIconRounded, color: AppColors.icons);

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? truckLocation = LatLng(13.623352, 123.188284);
  MapController mapController = MapController();
  Location location = Location();
  bool serviceEnabled = true;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  LatLng? currentLocation;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(_locationData?.latitude ?? 13.627546,
          _locationData?.longitude ?? 123.190330);
      mapController.move(currentLocation!, 18);
    });
  }

  /// Real-time Firestore Stream for User Data
  Stream<DocumentSnapshot> _userStream() {
    final user = _auth.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots();
  }

  void _adjustMapToBounds() {
    if (currentLocation != null && truckLocation != null) {
      final bounds =
          LatLngBounds.fromPoints([currentLocation!, truckLocation!]);

      // Calculate center
      final centerLat =
          (bounds.southWest.latitude + bounds.northEast.latitude) / 2;
      final centerLng =
          (bounds.southWest.longitude + bounds.northEast.longitude) / 2;
      final center = LatLng(centerLat, centerLng);

      // Calculate zoom level based on distance between bounds
      final zoom = _calculateZoomLevel(bounds);

      mapController.move(center, zoom); // Set the map to the center and zoom
    }
  }

  double _calculateZoomLevel(LatLngBounds bounds) {
    const int maxZoom = 18; // Maximum zoom level
    const int minZoom = 3; // Minimum zoom level

    // Calculate differences in coordinates
    final latDiff =
        (bounds.northEast.latitude - bounds.southWest.latitude).abs();
    final lngDiff =
        (bounds.northEast.longitude - bounds.southWest.longitude).abs();

    // Determine zoom dynamically (this is a rough example; tune as needed)
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    final zoom = maxZoom - (maxDiff * 10).ceil();
    return zoom
        .clamp(minZoom, maxZoom)
        .toDouble(); // Clamp zoom between min and max
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FlutterMap for displaying the interactive map
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation ?? LatLng(13.627546, 123.190330),
              initialZoom: 18,
              onMapReady: _adjustMapToBounds,
              /*
              MapOptions(
                onPositionChanged: (MapPosition position, bool hasGesture) {
                _adjustMapToBounds();
              },
              ),
              */
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              if (currentLocation != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: currentLocation!,
                      color: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                      useRadiusInMeter: true,
                      radius: 75,
                    ),
                  ],
                ),
              if (currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              if (truckLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: truckLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Settings button on the top-right
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 20),
              child: _settingsIcon(context),
            ),
          ),

          // Persistent Bottom Sheet with Real-Time User Data
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _userStream(),
                  builder: (context, snapshot) {
                    String? userName = 'Loading...';

                    if (snapshot.hasData && snapshot.data?.exists == true) {
                      userName = snapshot.data!['name'];
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration:
                                  BoxDecoration(color: AppColors.background),
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName ?? 'User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.plateNumber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Truck Icon
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                              ),
                              child: Icon(
                                Icons.local_shipping_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Truck Information
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Truck Collector',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Plate Number',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.plateNumber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsIcon(BuildContext context) {
    return IconButton(
      icon: settingIcon,
      color: AppColors.icons,
      iconSize: 24,
      tooltip: 'Settings',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => local_settings.Settings(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: iconBackgroundColor,
        fixedSize: const Size(30, 30),
        foregroundColor: outlinedColor,
      ),
    );
  }
}
