import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  static Future<void> launchUrlString({required String urlString}) async {
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

  static Future<bool> checkInternetConnection(
    BuildContext context,
    bool useDialog,
  ) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        if (useDialog) {
          log('use dialog');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('No Internet'),
                content: const Text('Please try again!!!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Internet. Please try again!!!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
      return false;
    }
    return true;
  }

  static Future<T?> withConnection<T>(
    BuildContext context,
    Future<T> Function() apiCall, {
    bool useDialog = false,
  }) async {
    if (await checkInternetConnection(
      context,
      useDialog,
    )) {
      try {
        return await apiCall();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
