import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_trashtrackr/core/config/assets/app_vectors.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signin.dart';
import 'package:new_trashtrackr/presentation/pages/auth/userSelectRegister.dart';

class SignupOrSigninPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
        children: [
          // Logo section
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 172), // Position logo slightly higher
            child: SvgPicture.asset(
              AppVectors.logo,
              height: 100,
              width: 100,
            ),
          ),

          Spacer(),

          // Buttons section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Login button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SigninPage()));
                },
                child: Text('Login',
                    style: TextStyle(fontSize: 18)), // Increased text size
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50), // Bigger button size
                  padding:
                      EdgeInsets.symmetric(vertical: 15), // Padding for height
                  foregroundColor: AppColors.textInButton,
                  backgroundColor: AppColors.background,
                ),
              ),
              SizedBox(width: 30), // Increased spacing between buttons
              // Register button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSelectionApp()));
                },
                child: Text('Register',
                    style: TextStyle(fontSize: 18)), // Increased text size
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50), // Bigger button size
                  padding:
                      EdgeInsets.symmetric(vertical: 15), // Padding for height
                  foregroundColor: AppColors.background,
                  backgroundColor: AppColors.button_1,
                ),
              ),
            ],
          ),
          SizedBox(height: 30), // Space below buttons
        ],
      ),
    );
  }
}
