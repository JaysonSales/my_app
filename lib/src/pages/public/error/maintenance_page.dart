import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/provider/core/config_provider.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance"),
        centerTitle: true,
      ),
      body: Center(
        child: configProvider.loading
            ? const CircularProgressIndicator()
            : configProvider.error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 100),
                      const SizedBox(height: 20),
                      const Text("Error loading configuration"),
                      Text(configProvider.error.toString(), textAlign: TextAlign.center),
                    ],
                  )
                : Builder(
                    builder: (context) {
                      final maintenanceConfig = configProvider.config?['maintenance'];
                      String message = "We'll be back soon!";
                      String? imageUrl;

                      if (maintenanceConfig is Map) {
                        message = maintenanceConfig['message'] ?? message;
                        imageUrl = maintenanceConfig['image'];
                      }
                      
                      Widget imageWidget = const Icon(Icons.build, color: Colors.orange, size: 100);
                      if (imageUrl != null) {
                          final assetPath = imageUrl.replaceFirst('package:', '');
                          imageWidget = Image.asset(
                            assetPath,
                            height: 150,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.build, color: Colors.orange, size: 100);
                            },
                          );
                      }


                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageWidget,
                          const SizedBox(height: 20),
                          const Text(
                            "Under Maintenance",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
