import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int maxLength;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        fillColor: Colors.blueAccent.shade700,
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        counterStyle:
            TextStyle(color: Colors.blueAccent.shade700, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
