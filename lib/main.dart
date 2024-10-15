import 'package:flutter/material.dart';
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

  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
