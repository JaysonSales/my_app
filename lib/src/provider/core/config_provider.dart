import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ConfigProvider');

class ConfigProvider with ChangeNotifier {
  bool _loading = true;
  Map<String, dynamic>? _config;
  String? _error;

  bool get loading => _loading;
  Map<String, dynamic>? get config => _config;
  String? get error => _error;

  ConfigProvider() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    _logger.info('Starting to load configuration...');
    try {
      rootBundle.evict('assets/config/config.json');

      final configString = await rootBundle.loadString(
        'assets/config/config.json',
      );
      _logger.fine('Configuration file loaded successfully.');

      final configJson = json.decode(configString);
      final tenant = configJson['tenant'];

      if (tenant == null || configJson[tenant] == null) {
        _logger.severe('Tenant not found or invalid in configuration!');
        throw Exception(
          'Failed to load configuration! Tenant not found or invalid.',
        );
      }

      _config = {
        'tenant': tenant,
        'tenantId': '$tenant-cln',
        ...configJson[tenant],
      };
      _error = null;
      _logger.info('Configuration loaded and processed successfully.');
    } catch (e) {
      _logger.severe('Error loading configuration: $e', e);
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
      _logger.info('Configuration loading finished. Loading state: $_loading');
    }
  }

  Future<void> reloadConfig() async {
    _loading = true;
    notifyListeners();
    await loadConfig();
  }
}
