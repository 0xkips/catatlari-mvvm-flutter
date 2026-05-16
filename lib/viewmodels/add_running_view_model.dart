import 'package:flutter/material.dart';
import '../models/running_model.dart';
import '../services/local_storage_service.dart';
import 'base_view_model.dart';

class AddRunningViewModel extends BaseViewModel {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController distanceKmController = TextEditingController();
  final TextEditingController distanceMeterController = TextEditingController();
  final TextEditingController durationHourController = TextEditingController();
  final TextEditingController durationMinuteController = TextEditingController();

  Future<void> saveRunning() async {
    if (dateController.text.isEmpty ||
        distanceKmController.text.isEmpty ||
        distanceMeterController.text.isEmpty ||
        durationHourController.text.isEmpty ||
        durationMinuteController.text.isEmpty) {
      throw Exception('Silakan isi semua data terlebih dahulu.');
    }

    final int kmValue = int.tryParse(distanceKmController.text) ?? 0;
    final int meterValue = int.tryParse(distanceMeterController.text) ?? 0;

    if (meterValue < 0 || meterValue > 999) {
      throw Exception('Kolom meter harus antara 0 dan 999.');
    }

    final totalKm = kmValue + meterValue / 1000;
    final distanceText = '${totalKm.toStringAsFixed(2).replaceAll('.', ',')} km';
    final durationText = '${durationHourController.text.padLeft(2, '0')} Jam ${durationMinuteController.text.padLeft(2, '0')} Menit';

    final newRunning = RunningModel(
      date: dateController.text,
      distance: distanceText,
      duration: durationText,
    );

    setLoading(true);
    try {
      await LocalStorageService.saveRunning(newRunning);
    } finally {
      setLoading(false);
    }
  }

  void clearControllers() {
    dateController.clear();
    distanceKmController.clear();
    distanceMeterController.clear();
    durationHourController.clear();
    durationMinuteController.clear();
  }

  @override
  void dispose() {
    dateController.dispose();
    distanceKmController.dispose();
    distanceMeterController.dispose();
    durationHourController.dispose();
    durationMinuteController.dispose();
    super.dispose();
  }
}
