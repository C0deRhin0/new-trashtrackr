import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:new_trashtrackr/presentation/home/pages/admin/adminverification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_trashtrackr/presentation/home/pages/settings.dart'
    as local_settings;

const outlinedColor = AppColors.background;
const iconBackgroundColor = AppColors.background;
final settingIconRounded = SymbolsGet.get('settings', SymbolStyle.rounded);
Icon settingIcon = Icon(settingIconRounded, color: AppColors.icons);

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class AdminModeWidget extends StatefulWidget {
  final LatLng? currentLocation; // Accept currentLocation as a parameter

  const AdminModeWidget({Key? key, required this.currentLocation})
      : super(key: key);

  @override
  _AdminModeWidgetState createState() => _AdminModeWidgetState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  MapController mapController = MapController();
  Location location = Location();
  bool serviceEnabled = true;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  LatLng? currentLocation;
  String? truckCollector = "Truck Collector";
  String? plateNumber = "Plate Number";
  LatLng? adminLocation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userName; // Store the user's name

  @override
  void initState() {
    super.initState();
    initLocation();
    _loadUserData(); // Load user data on initial launch
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData(); // Reload user data every time dependencies change
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
      log(_locationData.toString());
      currentLocation = LatLng(_locationData?.latitude ?? 13.631562151274863,
          _locationData?.longitude ?? 123.18439362255296);
      mapController.move(currentLocation!, 18);
    });
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;

    // Fetch user data
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
        });
      }
    }

    // Fetch the latest admin data
    final adminDoc = await _firestore.collection("admin").doc("latest").get();
    if (adminDoc.exists) {
      final adminData = adminDoc.data();
      setState(() {
        truckCollector = adminData?['adminName'] ?? "Unknown Admin";
        plateNumber = adminData?['plateNumber'] ?? "Unknown Plate";
        adminLocation = LatLng(
          adminData?['currentLocation']['latitude'] ?? 0.0,
          adminData?['currentLocation']['longitude'] ?? 0.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reload user data when navigating back
        await _loadUserData();
        return true; // Allow the pop to proceed
      },
      child: Scaffold(
        body: Stack(
          children: [
            // FlutterMap for displaying the interactive map
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentLocation ??
                    LatLng(13.63156215127486, 123.18439362255296),
                initialZoom: 18,
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
                          Icons.local_shipping_rounded,
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
                padding: const EdgeInsets.only(top: 40, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    color: AppColors.plateNumber,
                    onPressed: () async {
                      // Navigate to Settings and wait for a result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => local_settings.Settings(),
                        ),
                      );

                      // Reload user data if Settings triggers a refresh
                      if (result == true) {
                        await _loadUserData();
                      }
                    },
                  ),
                ),
              ),
            ),

            // admin mode widget
            AdminModeWidget(
              currentLocation: currentLocation, // Pass currentLocation here
            ),

            // Persistent Bottom Sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 200, // Fixed height for the bottom sheet
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAreaInfo(),
            const SizedBox(height: 25),
            _buildTruckInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // User Icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Icon(
            Icons.location_city_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 15),
        // User Information
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Area', // Display the name
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.plateNumber),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTruckInfo() {
    return Row(
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
          children: [
            Text(
              truckCollector ?? 'Truck Collector',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              plateNumber ?? 'Plate Number',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            if (adminLocation != null)
              Text(
                '(${adminLocation!.latitude.toStringAsFixed(5)}, '
                '${adminLocation!.longitude.toStringAsFixed(5)})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.plateNumber,
                ),
              ),
          ],
        ),
      ],
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
          builder: (context) => local_settings.Settings(), // Explicit reference
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

// Admin mode button on the top-right
class _AdminModeWidgetState extends State<AdminModeWidget> {
  bool isVerified = false; // Tracks verification status
  bool isAdminMode = false; // Tracks admin mode

  @override
  void initState() {
    super.initState();
    _loadVerificationStatus(); // Load verification status from preferences
  }

  Future<void> _loadVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    // Reset isVerified for new users
    if (user != null) {
      final isSameUser = prefs.getString('lastVerifiedUser') == user.uid;
      setState(() {
        isVerified = isSameUser ? prefs.getBool('isVerified') ?? false : false;
      });

      // Save the current user's UID as the last logged-in user
      if (!isSameUser) {
        await prefs.setBool('isVerified', false); // Reset verification
        await prefs.setString('lastVerifiedUser', user.uid);
      }
    }
  }

  Future<void> _saveVerificationStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVerified', status);
  }

  void _updateAdminData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("No authenticated user found. Please log in.");
      return; // Exit if no user is logged in
    }

    //if (widget.currentLocation == null) {
    //debugPrint("No location found. Cannot update admin data.");
    //return; // Exit if location is unavailable
    //}

    final adminData = {
      "adminName": user.displayName ?? user.email ?? "Unknown Admin",
      "plateNumber": "Verified Plate Number",
      "currentLocation": {
        "latitude": widget.currentLocation!.latitude,
        "longitude": widget.currentLocation!.longitude,
      },
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection("admin")
          .doc("latest")
          .set(adminData);

      debugPrint("Admin data successfully updated: $adminData");
    } catch (e) {
      debugPrint("Failed to update admin data: $e");
    }
  }

  void _toggleAdminMode(bool value) {
    setState(() {
      isAdminMode = value;
    });

    if (isAdminMode) {
      _triggerAdminFunctions();
      _updateAdminData(); // Save admin details when mode is enabled
    } else {
      _disableAdminFunctions();
    }
  }

  void _triggerAdminFunctions() {
    // Placeholder for enabling admin mode features
    debugPrint("Admin mode enabled.");
  }

  void _disableAdminFunctions() {
    // Placeholder for disabling admin mode features
    debugPrint("Admin mode disabled.");
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.verified_user),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text("Admin Mode"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Admin Mode:"),
                                Switch(
                                  value: isAdminMode,
                                  onChanged: isVerified
                                      ? (value) {
                                          setState(() {
                                            _toggleAdminMode(value);
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isVerified) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminVerification(),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      isVerified = true;
                                    });
                                    _saveVerificationStatus(true);
                                    _updateAdminData(); // Save admin details after verification
                                  }
                                }
                              },
                              child: Text(isVerified ? "Verified" : "Verify"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
