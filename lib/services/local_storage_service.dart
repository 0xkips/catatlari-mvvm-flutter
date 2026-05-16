import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/running_model.dart';
  
  class LocalStorageService {
  static Future<void> saveUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  static Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('name') ?? '',
      'email': prefs.getString('email') ?? '',
      'password': prefs.getString('password') ?? '',
    };
  }

  static Future<void> saveRunning(
    RunningModel running,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> runningList =
        prefs.getStringList('running_logs') ?? [];

    runningList.add(jsonEncode(running.toJson()));

    await prefs.setStringList('running_logs', runningList);
  }

  static Future<List<RunningModel>> getRunningLogs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> runningList =
        prefs.getStringList('running_logs') ?? [];

    return runningList.map((item) {
      return RunningModel.fromJson(jsonDecode(item));
    }).toList();
  }

  static Future<void> deleteRunningLog(int index) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> runningList =
        prefs.getStringList('running_logs') ?? [];

    runningList.removeAt(index);

    await prefs.setStringList('running_logs', runningList);
  }
}