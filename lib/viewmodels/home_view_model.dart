import 'package:flutter/material.dart';
import '../models/running_model.dart';
import '../services/local_storage_service.dart';
import 'base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  List<RunningModel> _runningLogs = [];

  List<RunningModel> get runningLogs => _runningLogs;

  Future<void> loadRunningLogs() async {
    setLoading(true);
    try {
      _runningLogs = await LocalStorageService.getRunningLogs();
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteLog(int index) async {
    setLoading(true);
    try {
      await LocalStorageService.deleteRunningLog(index);
      await loadRunningLogs();
    } finally {
      setLoading(false);
    }
  }

  Future<Map<String, String>> getUser() async {
    return await LocalStorageService.getUser();
  }
}
