import 'package:flutter/material.dart';

class CustomDailogButton extends StatelessWidget {
  final VoidCallback voidCallback;
  final String buttonName;
  const CustomDailogButton({Key? key, required this.buttonName, required this.voidCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: voidCallback,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Text(buttonName),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent.shade700),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
