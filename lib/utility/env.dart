import 'dart:io';

class Env {
  static final Map<String, String> _env = {};

  static Future<void> load() async {
    final file = File('.env');
    final lines = await file.readAsLines();
    for (var line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        _env[parts[0].trim()] = parts[1].trim();
      }
    }
  }

  static String? get(String key) {
    return _env[key];
  }
}
