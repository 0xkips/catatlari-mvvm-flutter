import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';
import 'base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  void initializeControllers(UserModel user) {
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    passwordController = TextEditingController(text: user.password);
  }

  Future<UserModel?> saveProfile() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      throw Exception('Semua field harus diisi.');
    }

    final updatedUser = UserModel(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    setLoading(true);
    try {
      await LocalStorageService.saveUser(
        name: updatedUser.name,
        email: updatedUser.email,
        password: updatedUser.password,
      );
      return updatedUser;
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
