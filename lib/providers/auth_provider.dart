import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/mock_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final MockAuthService _authService = MockAuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signInWithEmail(email, password);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup(
    String email,
    String password,
    String name,
    String phone,
    UserType userType,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        userType: userType,
      );
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  // Additional methods for compatibility with screens
  Future<bool> signInWithEmail(String email, String password) async {
    return await login(email, password);
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType userType,
  }) async {
    return await signup(email, password, name, phone, userType);
  }

  Future<void> signOut() async {
    await logout();
  }

  Future<void> quickLoginAsPatient() async {
    await login('patient@demo.com', 'demo123');
  }

  Future<void> quickLoginAsPhysio() async {
    await login('physio@demo.com', 'demo123');
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
