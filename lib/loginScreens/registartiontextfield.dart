import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegistrationTextField extends StatefulWidget {
  final IconData icon;
  final String text;
  final String? Function(String?)? validator;
  TextEditingController controller = TextEditingController();
  RegistrationTextField(
      {super.key,
      required this.icon,
      required this.text,
      required this.controller, 
      required this.validator});

  @override
  State<RegistrationTextField> createState() => _RegistrationTextFieldState();
}

class _RegistrationTextFieldState extends State<RegistrationTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
            left: 3.0,
          ),
          child: Icon(
            widget.icon,
            color: Colors.black,
            size: 22,
          ),
        ),
        hintText: widget.text,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
