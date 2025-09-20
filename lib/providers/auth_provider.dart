import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;
  static const String _authKey = 'is_authenticated';
  static const String _emailKey = 'user_email';
  static const String _nameKey = 'user_name';

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(_authKey) ?? false;
    _userEmail = prefs.getString(_emailKey);
    _userName = prefs.getString(_nameKey);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation for demo
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = email.split('@')[0]; // Simple username extraction

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, true);
      await prefs.setString(_emailKey, email);
      await prefs.setString(_nameKey, _userName!);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userEmail = null;
    _userName = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);

    notifyListeners();
  }

  Future<bool> register(String email, String password, String name) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation for demo
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = name;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, true);
      await prefs.setString(_emailKey, email);
      await prefs.setString(_nameKey, name);

      notifyListeners();
      return true;
    }
    return false;
  }
}

