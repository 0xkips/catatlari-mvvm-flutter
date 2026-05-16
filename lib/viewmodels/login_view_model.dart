import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';
import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  bool _isPasswordHidden = true;

  bool get isPasswordHidden => _isPasswordHidden;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  Future<UserModel?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password tidak boleh kosong');
    }

    setLoading(true);
    try {
      final user = await LocalStorageService.getUser();

      if (email == user['email'] && password == user['password']) {
        return UserModel(
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          password: user['password'] ?? '',
        );
      } else {
        throw Exception('Email atau password salah');
      }
    } finally {
      setLoading(false);
    }
  }
}
