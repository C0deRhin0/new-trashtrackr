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
        child: Padding(
          padding: const EdgeInsets.only( top: 20, right: 20),
          child: _settingsIcon(context),
        )
      ),
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
    )
  );
}