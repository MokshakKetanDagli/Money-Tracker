import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback voidCallback;
  final String buttonName;
  const CustomElevatedButton({Key? key, required this.voidCallback, required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: voidCallback,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
