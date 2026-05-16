import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/add_running_view_model.dart';

class AddRunningPage extends StatefulWidget {
  const AddRunningPage({super.key});

  @override
  State<AddRunningPage> createState() => _AddRunningPageState();
}

class _AddRunningPageState extends State<AddRunningPage> {
  Future<void> _pickDate(AddRunningViewModel viewModel) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      viewModel.dateController.text =
          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _selectDuration(AddRunningViewModel viewModel) async {
    int selectedHour = int.tryParse(viewModel.durationHourController.text) ?? 1;
    int selectedMinute =
        int.tryParse(viewModel.durationMinuteController.text) ?? 1;
    selectedHour = selectedHour.clamp(0, 23);
    selectedMinute = selectedMinute.clamp(0, 59);

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Durasi'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedHour,
                          decoration: const InputDecoration(labelText: 'Jam'),
                          items: List.generate(
                            24,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedHour = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedMinute,
                          decoration: const InputDecoration(labelText: 'Menit'),
                          items: List.generate(
                            59,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedMinute = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'hour': selectedHour,
                  'minute': selectedMinute,
                });
              },
              child: const Text('Pilih'),
            ),
          ],
        );
      },
    );

    if (result != null && mounted) {
      viewModel.durationHourController.text = result['hour']!.toString();
      viewModel.durationMinuteController.text = result['minute']!.toString();
    }
  }

  Future<void> _handleSaveRunning(AddRunningViewModel viewModel) async {
    try {
      await viewModel.saveRunning();
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String label, {Widget? prefix}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      prefixIcon: prefix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddRunningViewModel(),
      child: Consumer<AddRunningViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F4FF),
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFAF1F8),
                    Color(0xFFF0F4FF),
                    Color(0xFFE3FBF8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Let's Share",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'your journey!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Tanggal Lari',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: viewModel.dateController,
                              readOnly: true,
                              onTap: () => _pickDate(viewModel),
                              decoration: _buildInputDecoration(
                                'Pilih Tanggal',
                                prefix: const Icon(Icons.calendar_month,
                                    color: Color(0xFF7C7C8A)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Jarak',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: viewModel.distanceKmController,
                                    keyboardType: TextInputType.number,
                                    decoration: _buildInputDecoration('KM'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller:
                                        viewModel.distanceMeterController,
                                    keyboardType: TextInputType.number,
                                    decoration: _buildInputDecoration('M'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Durasi',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller:
                                        viewModel.durationHourController,
                                    readOnly: true,
                                    onTap: () => _selectDuration(viewModel),
                                    decoration:
                                        _buildInputDecoration('Jam (HH)'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller:
                                        viewModel.durationMinuteController,
                                    readOnly: true,
                                    onTap: () => _selectDuration(viewModel),
                                    decoration:
                                        _buildInputDecoration('Menit (MM)'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () => _handleSaveRunning(viewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5BC4B8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Simpan',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
