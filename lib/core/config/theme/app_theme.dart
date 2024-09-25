import 'app_colors.dart';
import 'package:flutter/material.dart';


class OnboardingTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button_1, // Green button
        textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textOnboard,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

class LoginSignupOnboardingTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.placeholder, // Login button background (White)
        textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textOnboard_2, // Login button text (Black)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static ButtonStyle signupButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.button_1, // Green Signup button background
    textStyle: const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textOnboard, // White Signup button text
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

class LoginPageTheme {
  static final theme = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.placeholder, // Placeholder background (White)
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.placeholderBorder), // Placeholder border (Gray)
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.placeholderBorder), // Placeholder border (Gray)
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.mainpageText), // Text (Black)
      bodyMedium: TextStyle(color: AppColors.mainpageText), // Text (Black)
      titleMedium: TextStyle(color: AppColors.main), // Forgot password text (Green)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button_1, // Button background (Green)
      ),
    ),
  );

  static const TextStyle registerTextStyle = TextStyle(
    color: AppColors.main, // Register text (Green)
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class SignupPageTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.placeholder, // Placeholder background (white)
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholderBorder), // Placeholder border (gray)
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholderBorder),
      ),
    ),
    shadowColor: AppColors.dropShadows, // Placeholder drop shadow (gray)
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.mainpageText), // Black text
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // Login text link
        foregroundColor: AppColors.switchButton, // Green text
      ),
    ),
  );
}

class MainPageTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.carouselBackground, // Gray background

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background, // White navbar
    ),

    iconTheme: const IconThemeData(
      color: AppColors.icons, // Black icons
    ),

    // Add Drawer Theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.background, // White background for drawer
    ),

    // Customize ListTile for Drawer Items
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.icons, // Black truck icon
      textColor: AppColors.mainpageText, // Black text for drawer items
    ),

    // Use text theme for plate number
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: AppColors.plateNumber, // Green color for plate number text
      ),
    ),
  );
}


class SettingsPageTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.placeholder, // Placeholder background (white)
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholderBorder), // Placeholder border (gray)
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholderBorder),
      ),
    ),
    shadowColor: AppColors.dropShadows, // Placeholder drop shadow (gray)
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.mainpageText), // Black text
    ),
    iconTheme: const IconThemeData(
      color: AppColors.icons, // Black icons
    ),
  );
}
