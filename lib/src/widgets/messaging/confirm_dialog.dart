import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String message,
    String acceptMessage = 'Confirm',
    required VoidCallback onAccept,
    String? successMessage,
  }) {
    Future<void> handleAccept(BuildContext dialogContext) async {
      Navigator.of(dialogContext).pop();
      if (successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      onAccept();
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(acceptMessage),
              onPressed: () async {
                await handleAccept(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
