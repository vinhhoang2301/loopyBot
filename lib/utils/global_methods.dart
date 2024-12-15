import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> launchSlackConfigUrl({required String urlString}) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      log('Error launching URL: $e');
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
