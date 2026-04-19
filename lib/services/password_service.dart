// lib/services/password_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PasswordService {
  static const _key = 'app_password';

  /// Save a new password (plain text for now — can be hashed later)
  static Future<void> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, password);
  }

  /// Get the stored password (null if none set)
  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  /// Check if the given password matches the stored one
  static Future<bool> checkPassword(String input) async {
    final stored = await getPassword();
    return stored != null && stored == input;
  }

  /// Returns true if a password is already set
  static Future<bool> hasPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }

  /// Remove the stored password (e.g., for reset)
  static Future<void> clearPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
