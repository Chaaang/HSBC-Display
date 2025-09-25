import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blueGrey;
      icon = Icons.info;
      break;
  }

  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    content: Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
