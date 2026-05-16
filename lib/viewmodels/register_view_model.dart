import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import 'base_view_model.dart';

class RegisterViewModel extends BaseViewModel {
  bool _isPasswordHidden = true;
  bool _isConfirmHidden = true;

  bool get isPasswordHidden => _isPasswordHidden;
  bool get isConfirmHidden => _isConfirmHidden;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _isConfirmHidden = !_isConfirmHidden;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password, String confirmPassword) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception('Semua field harus diisi');
    }

    if (password != confirmPassword) {
      throw Exception('Password tidak sama');
    }

    setLoading(true);
    try {
      await LocalStorageService.saveUser(
        name: name,
        email: email,
        password: password,
      );
    } finally {
      setLoading(false);
    }
  }
}
