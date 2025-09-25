import 'package:flutter/material.dart';
import 'package:my_app/src/provider/messaging/alert_provider.dart';

class ConfirmDialog {
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String message,
    String acceptMessage = 'Confirm',
    required Future<void> Function() onAccept,
    String? successMessage,
    String? errorMessage = "An error occurred",
  }) {
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
                Navigator.of(dialogContext).pop();
                try {
                  await onAccept();
                  if (successMessage != null) {
                    AlertProvider.success(successMessage);
                  }
                } catch (e) {
                  AlertProvider.error('$errorMessage\n$e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
