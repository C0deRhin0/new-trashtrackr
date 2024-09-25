// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/assets/app_vectors.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/core/config/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: signInLink(context),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 100,
              horizontal: 70,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppVectors.logo,
                  height: 100,
                  width: 100,
                ),
                _loginTitle(),
                const SizedBox(height: 20),
                _emailField(context),
                const SizedBox(height: 20),
                _passwordField(context),
                const SizedBox(height: 20),
                forgotPasswordButton(context),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Sign In',
                      style: TextStyle(
                        color: AppColors.textInButton
                      )),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: AppColors.switchButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginTitle() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }


  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: 'Enter Password',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }
  Widget forgotPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignupPage(),
                ),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.switchButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget signInLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account yet?",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mainpageText,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignupPage(),
                ),
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.switchButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
