import 'app_colors.dart';
import 'package:flutter/material.dart';


class OnboardingTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button_1, // Green button
        textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text_onboard,
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
          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text_onboard_2, // Login button text (Black)
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
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text_onboard, // White Signup button text
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
        borderSide: BorderSide(color: AppColors.placeholder_boarder), // Placeholder border (Gray)
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholder_boarder), // Placeholder border (Gray)
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.mainpage_text), // Text (Black)
      bodyMedium: TextStyle(color: AppColors.mainpage_text), // Text (Black)
      titleMedium: TextStyle(color: AppColors.main), // Forgot password text (Green)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button_1, // Button background (Green)
      ),
    ),
  );

  static final TextStyle registerTextStyle = TextStyle(
    color: AppColors.main, // Register text (Green)
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class SignupPageTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.placeholder, // Placeholder background (white)
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholder_boarder), // Placeholder border (gray)
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholder_boarder),
      ),
    ),
    shadowColor: AppColors.drop_shadows, // Placeholder drop shadow (gray)
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.mainpage_text), // Black text
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // Login text link
        foregroundColor: AppColors.switch_button, // Green text
      ),
    ),
  );
}

class MainPageTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.carousel_background, // Gray background
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background, // White navbar
    ),
    iconTheme: IconThemeData(
      color: AppColors.icons, // Black icons
    ),
  );
}

class SettingsPageTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background, // White background
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.placeholder, // Placeholder background (white)
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholder_boarder), // Placeholder border (gray)
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholder_boarder),
      ),
    ),
    shadowColor: AppColors.drop_shadows, // Placeholder drop shadow (gray)
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.mainpage_text), // Black text
    ),
    iconTheme: IconThemeData(
      color: AppColors.icons, // Black icons
    ),
  );
}
