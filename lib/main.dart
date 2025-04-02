
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_mobile_camion/loginScreens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobile_camion/screens.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
    Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const Screens(),
    );
  }
}