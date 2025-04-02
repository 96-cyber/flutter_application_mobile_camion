import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginScreens/login.dart';

class Mission extends StatefulWidget {
  const Mission({super.key});

  @override
  State<Mission> createState() => _MissionState();
}

class _MissionState extends State<Mission> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: 
        IconButton(onPressed: ()async{
           await FirebaseAuth.instance.signOut();
                                  if (!mounted) return;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => const LoginPage()),
                                      (route) => false);
        },
         icon: const Icon(Icons.logout),),
          )
        ],
      ),
    );
  }
}