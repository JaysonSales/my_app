import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigService with ChangeNotifier {
  bool _loading = true;
  Map<String, dynamic>? _config;
  String? _error;

  bool get loading => _loading;
  Map<String, dynamic>? get config => _config;
  String? get error => _error;

  ConfigService() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    try {
      rootBundle.evict('assets/config/config.json');
      
      final configString = await rootBundle.loadString('assets/config/config.json');
      final configJson = json.decode(configString);
      final tenant = configJson['tenant'];
      if (tenant == null || configJson[tenant] == null) {
        throw Exception('Failed to load configuration! Tenant not found or invalid.');
      }
      _config = {
        'tenant': tenant,
        'tenantId': '$tenant-cln',
        ...configJson[tenant],
      };
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> reloadConfig() async {
    _loading = true;
    notifyListeners();
    await loadConfig();
  }
}
