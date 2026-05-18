import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quran_viewmodel.dart';
import '../theme/app_theme.dart';
import 'quran_detail_view.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuranViewModel()..fetchSurat(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Al-Quran'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // To be implemented: Search Surah
              },
            ),
          ],
        ),
        body: Consumer<QuranViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
            }

            if (vm.suratList.isEmpty) {
              return const Center(child: Text('Data tidak tersedia'));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: vm.suratList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final surat = vm.suratList[index];
                return Card(
                  elevation: 0,
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppTheme.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      final vm = context.read<QuranViewModel>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: vm,
                            child: QuranDetailView(surat: surat),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Number Badge
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary.withOpacity(0.1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              surat.number.toString(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Surah Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surat.arabName, // This maps to namaLatin
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${surat.name} • ${surat.ayatCount} Ayat',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Trailing Arabic Icon or Action
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
