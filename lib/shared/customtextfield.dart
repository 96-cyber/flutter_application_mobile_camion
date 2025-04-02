import 'package:flutter/material.dart';

class AddAvisTField extends StatelessWidget {
  final String title;
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const AddAvisTField({super.key, required this.title, required this.text, required this.controller, required this.validator});

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(title, style:  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10,),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: text,
              hintStyle: const TextStyle(color: Colors.black87),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.black45,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 220, 220, 220),
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ],
            )
        ;
  }
}