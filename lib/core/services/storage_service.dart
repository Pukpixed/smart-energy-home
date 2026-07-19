import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  Future<void> saveString(
    String key,
    String value,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  Future<void> saveBool(
    String key,
    bool value,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  Future<bool> getBool(
    String key, {
    bool defaultValue = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
