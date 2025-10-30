import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? get userEmail => _currentUser?.email;
  String? get userName => _currentUser?.userMetadata?['full_name'] ?? _currentUser?.email?.split('@')[0];
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initialize();
  }

  void _initialize() {
    // Get current user
    _currentUser = SupabaseService.client.auth.currentUser;
    
    // Listen to auth state changes
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      notifyListeners();
    });
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await SupabaseService().signInWithEmail(email, password);
      _currentUser = response.user;
      
      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await SupabaseService().signUpWithEmail(email, password, name);
      _currentUser = response.user;
      
      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await SupabaseService().signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}

