import 'package:flutter/material.dart';

class AlertProvider {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    required Color color,
    bool dismissible = true,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        action: dismissible
            ? SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: messenger.hideCurrentSnackBar,
              )
            : null,
      ),
    );
  }

  static void info(String msg, {bool dismissible = true}) =>
      show(msg, color: Colors.blue, dismissible: dismissible);

  static void success(String msg, {bool dismissible = true}) =>
      show(msg, color: Colors.green, dismissible: dismissible);

  static void warning(String msg, {bool dismissible = true}) =>
      show(msg, color: Colors.orange, dismissible: dismissible);

  static void error(String msg, {bool dismissible = true}) =>
      show(msg, color: Colors.red, dismissible: dismissible);
}
