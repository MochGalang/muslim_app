import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/doa_viewmodel.dart';
import '../theme/app_theme.dart';

class DoaView extends StatelessWidget {
  const DoaView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoaViewModel()..fetchDoa(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Doa Harian'),
        ),
        body: Consumer<DoaViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
            }

            if (vm.doaList.isEmpty) {
              return const Center(child: Text('Data tidak tersedia'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.doaList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final doa = vm.doaList[index];
                return Card(
                  elevation: 0,
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: AppTheme.primary.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Row(
                          children: [
                            const Icon(Icons.star_border_rounded, color: AppTheme.secondary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                doa.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Arabic Text
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            doa.arab,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              height: 1.8,
                              color: Theme.of(context).textTheme.displayLarge?.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Latin Text
                        Text(
                          doa.latin,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppTheme.primary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // Translation
                        Text(
                          doa.translation,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ],
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
