import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quran_viewmodel.dart';
import '../models/quran_model.dart';
import '../theme/app_theme.dart';

class QuranDetailView extends StatefulWidget {
  final QuranSurat surat;

  const QuranDetailView({super.key, required this.surat});

  @override
  State<QuranDetailView> createState() => _QuranDetailViewState();
}

class _QuranDetailViewState extends State<QuranDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().fetchDetailSurat(widget.surat.number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surat.arabName),
      ),
      body: Consumer<QuranViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
          }

          if (vm.ayatList.isEmpty) {
            return const Center(child: Text('Gagal memuat ayat'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.ayatList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final ayat = vm.ayatList[index];
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Badge nomor ayat & action
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary.withOpacity(0.1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              ayat.nomorAyat.toString(),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Teks Arab
                      Text(
                        ayat.teksArab,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          height: 2.0,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Teks Latin
                      Text(
                        ayat.teksLatin,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.primary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Terjemahan
                      Text(
                        ayat.teksIndonesia,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
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
    );
  }
}
