import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/assets/app_vectors.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_trashtrackr/data/models/auth/create_user_req.dart';
import 'package:new_trashtrackr/domain/usecases/auth/signup.dart';
import 'package:new_trashtrackr/presentation/pages/auth/admin/adminlogin.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';
import 'package:new_trashtrackr/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRegistrationPage extends StatefulWidget {
  AdminRegistrationPage({super.key});

  @override
  _AdminRegistrationPageState createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupOrSigninPage()),
          ),
        ),
        backgroundColor: Colors.transparent,
      )),
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
                _registerTitle(),
                const SizedBox(height: 20),
                _nameField(context),
                const SizedBox(height: 20),
                _emailField(context),
                const SizedBox(height: 20),
                _passwordField(context),
                const SizedBox(height: 20),
                _confirmPasswordField(context),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Use the SignupUseCase to register the user
                    var result = await sl<SignupUseCase>().call(
                      params: CreateUserReq(
                        fullName: _name.text.trim(),
                        email: _email.text.trim(),
                        password: _password.text.trim(),
                        confirmPassword: _confirmPassword.text.trim(),
                      ),
                    );

                    result.fold((failureMessage) {
                      // Show an error message if registration fails
                      var snackbar = SnackBar(content: Text(failureMessage));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }, (success) async {
                      // On successful registration, get the current user
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        try {
                          // Add or update the user document in Firestore
                          final docRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid);
                          await docRef.set({
                            'name': _name.text.trim(), // Set the user's name
                            'email': _email.text.trim(), // Set the user's email
                            'phone': '', // Optional: default phone
                            'profileImageUrl':
                                '', // Optional: default profile image
                          });
                        } catch (e) {
                          var snackbar = SnackBar(
                            content: Text(
                                'Error updating user details in Firestore: $e'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      }

                      // Navigate to the HomePage
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const HomePage(title: 'Home Page'),
                        ),
                        (route) => false,
                      );
                    });
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: AppColors.textInButton),
                  ),
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

  Widget _registerTitle() {
    return const Text(
      'Driver Register',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _nameField(BuildContext context) {
    return TextField(
      controller: _name,
      decoration: const InputDecoration(
        hintText: 'Enter name',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
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
      obscureText: isPasswordHidden,
      decoration: InputDecoration(
        hintText: 'Enter Password',
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordHidden ? Icons.visibility_off : Icons.visibility,
          ),
          color: AppColors.iconSecondary,
          onPressed: () {
            setState(() {
              isPasswordHidden = !isPasswordHidden;
            });
          },
        ),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _confirmPasswordField(BuildContext context) {
    return TextField(
      controller: _confirmPassword,
      obscureText: isPasswordHidden,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordHidden ? Icons.visibility_off : Icons.visibility,
          ),
          color: AppColors.iconSecondary,
          onPressed: () {
            setState(() {
              isPasswordHidden = !isPasswordHidden;
            });
          },
        ),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
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
            'Already have an account?',
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
                  builder: (BuildContext context) => AdminLoginPage(),
                ),
              );
            },
            child: const Text(
              'Sign In',
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
