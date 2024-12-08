import 'package:flutter/material.dart';

class Utils {
  Utils(this.context);

  final BuildContext context;

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget sheet,
    bool showFullScreen = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: showFullScreen,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return sheet;
      },
    );
  }
}
