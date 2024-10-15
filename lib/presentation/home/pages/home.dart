import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:material_symbols_icons/get.dart';
import 'settings.dart';

const outlinedColor = AppColors.background;
const iconBackgroundColor = AppColors.background;
final settingIconRounded = SymbolsGet.get('settings', SymbolStyle.rounded);
Icon settingIcon = Icon(settingIconRounded, color: AppColors.icons);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.main,
        body: Align(
          alignment: Alignment.topRight,
          child: _settingsIcon(context),
        ));
  }
}

Widget _settingsIcon(BuildContext context) {
  return IconButton(
    icon: settingIcon,
    iconSize: 24,
    tooltip: 'Settings',
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SettingsPage(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: iconBackgroundColor,
      foregroundColor: outlinedColor,
    ),
  );
}
