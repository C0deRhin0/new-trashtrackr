import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:material_symbols_icons/get.dart';
import 'settings.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

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
  MapController mapController = MapController();
  Location location = Location();
  bool serviceEnabled = true;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  LatLng? currentLocation;

  @override
  void initState() {
    initLocation();
    super.initState();
  }

  initLocation() async {
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
      currentLocation = LatLng(_locationData?.latitude ?? 13.627546, _locationData?.longitude ?? 123.190330);
      mapController.move(currentLocation!, 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation ?? LatLng(13.627546, 123.190330),
              initialZoom: 15,
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
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ], 
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: _settingsIcon(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapWidget(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(13.627546, 123.190330),
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ),
      ],
    );
  }
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
          builder: (context) => Settings(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: iconBackgroundColor,
        fixedSize: const Size(30, 30),
        foregroundColor: outlinedColor,
      ));
}
