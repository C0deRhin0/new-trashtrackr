import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_trashtrackr/core/config/assets/app_vectors.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  void _inorupredirect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupOrSigninPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showSplash ? _SplashScreen() : _Start(_inorupredirect),
    );
  }

  Widget _SplashScreen() {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(bottom: 472),
      child: Center(
        child: SvgPicture.asset(
          AppVectors.logo,
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}

Widget _Start(VoidCallback onStartPressed) {
  return Stack(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 472),  // Add the same bottom padding
        child: Align(
          alignment: Alignment.center,  // Keep it centered horizontally
          child: SvgPicture.asset(
            AppVectors.logo,
            height: 100,
            width: 100,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 2000),
              builder: (BuildContext context, double opacity, Widget? child) {
                return Opacity(
                  opacity: opacity,
                  child: ElevatedButton(
                    onPressed: onStartPressed,
                    child: Text('Start', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        foregroundColor: AppColors.background,
                        backgroundColor: AppColors.button_1),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    ],
  );
}
