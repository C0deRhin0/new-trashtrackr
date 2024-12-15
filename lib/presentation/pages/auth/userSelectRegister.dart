import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/pages/auth/admin/adminregistration.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signup_or_signin.dart';

void main() {
  runApp(UserSelectionApp());
}

class UserSelectionApp extends StatelessWidget {
  const UserSelectionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserSelectionScreen(),
      routes: {
        // '/adminregister': (context) => AdminRegistrationPage(),
        '/residentregister': (context) => SignupPage(),
      },
    );
  }
}

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
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
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Which User are you?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.plateNumber,
              ),
            ),
            SizedBox(height: 40),
            // Driver Button
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/adminregister');
              },
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green, // Button background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Driver",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Resident Button
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/residentregister');
              },
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green, // Button background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Resident",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
