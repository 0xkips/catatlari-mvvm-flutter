import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../viewmodels/home_view_model.dart';
import 'add_running_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String name;

  const HomePage({super.key, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadRunningLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddRunningPage()),
                );

                if (result == true) {
                  viewModel.loadRunningLogs();
                }
              },
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) async {
                if (index == 2) {
                  final userData =
                      await viewModel.getUser();
                  final user = UserModel(
                    name: userData['name'] ?? '',
                    email: userData['email'] ?? '',
                    password: userData['password'] ?? '',
                  );
                  if (!mounted) return;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                  );
                  return;
                }
                if (index == 1) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRunningPage()),
                  );

                  if (result == true) {
                    viewModel.loadRunningLogs();
                  }
                  return;
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF7D7D7),
                    Color(0xFFD9C2F0),
                    Color(0xFFC7EDF5)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Halo, ${widget.name}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Apa kabarmu hari ini?',
                        style:
                            TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Running Logs',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: viewModel.isLoading && viewModel.runningLogs.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : viewModel.runningLogs.isEmpty
                                ? const Center(
                                    child: Text('Belum ada data running'))
                                : ListView.builder(
                                    itemCount: viewModel.runningLogs.length,
                                    itemBuilder: (context, index) {
                                      final running = viewModel.runningLogs[index];

                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 18),
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                              blurRadius: 6,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemRow(
                                                  Icons.calendar_month,
                                                  'Tanggal Lari',
                                                  running.date,
                                                ),
                                                const SizedBox(height: 15),
                                                itemRow(
                                                  Icons.directions_run,
                                                  'Jarak Lari',
                                                  running.distance,
                                                ),
                                                const SizedBox(height: 15),
                                                itemRow(
                                                  Icons.timer_outlined,
                                                  'Durasi Lari',
                                                  running.duration,
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                viewModel.deleteLog(index);
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
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

  Widget itemRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value),
          ],
        ),
      ],
    );
  }
}
