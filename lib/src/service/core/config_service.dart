import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String tenant;
  final Map<String, dynamic> tenantConfig;

  AppConfig({required this.tenant, required this.tenantConfig});

  static Future<AppConfig> load() async {
    final String raw = await rootBundle.loadString('assets/config/config.json');
    final Map<String, dynamic> data = jsonDecode(raw);

    final String tenant = data['tenant'];
    final Map<String, dynamic> tenantConfig = data[tenant];

    return AppConfig(tenant: tenant, tenantConfig: tenantConfig);
  }

  String get apiHost => tenantConfig['api']['host'];
  String get appName => tenantConfig['app']['name'];
  bool get maintenanceMode => tenantConfig['maintenance']['enabled'];
}
