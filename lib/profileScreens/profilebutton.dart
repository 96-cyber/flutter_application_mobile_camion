// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../shared/colors.dart';

class ProfileButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String textButton;
  const ProfileButton({super.key, required this.onPressed, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(mainColor),
           padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        child:  Text(
          textButton,
          style: const TextStyle(fontSize: 17, color: whiteColor),
        ));
  }
}