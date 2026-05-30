import 'package:flutter/material.dart';

class CustomBotton extends StatelessWidget {
  final Color fillcolor;
  final Color fontcolor;
  final String label;
  final VoidCallback onPressed;
  CustomBotton({
    super.key,
    required this.fillcolor,
    required this.fontcolor,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: fontcolor)),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(30, 43)),
          backgroundColor: MaterialStateProperty.all(fillcolor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}
