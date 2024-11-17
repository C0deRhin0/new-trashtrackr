import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_trashtrackr/core/config/theme/app_colors.dart';
import 'package:new_trashtrackr/presentation/home/pages/home.dart';
import 'package:new_trashtrackr/presentation/pages/splash/splash.dart';
import 'package:new_trashtrackr/presentation/pages/auth/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.truckMarker),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
