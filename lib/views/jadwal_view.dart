import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/jadwal_viewmodel.dart';
import '../theme/app_theme.dart';

class JadwalView extends StatelessWidget {
  const JadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JadwalViewModel()..fetchJadwal(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal Shalat'),
        ),
        body: Consumer<JadwalViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
            }

            if (vm.jadwalList.isEmpty) {
              return const Center(child: Text('Data tidak tersedia'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.jadwalList.length,
              itemBuilder: (context, index) {
                final j = vm.jadwalList[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, Color(0xFF003527)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Saat Ini',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white70,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppTheme.secondary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Jakarta, Indonesia', // This could be dynamic later
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            j.tanggal,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Waktu Shalat',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildTimeCard(context, 'Subuh', j.subuh, Icons.wb_twilight),
                    _buildTimeCard(context, 'Dzuhur', j.dzuhur, Icons.wb_sunny),
                    _buildTimeCard(context, 'Ashar', j.ashar, Icons.cloud),
                    _buildTimeCard(context, 'Maghrib', j.maghrib, Icons.nights_stay),
                    _buildTimeCard(context, 'Isya', j.isya, Icons.dark_mode),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, String name, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              time,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
