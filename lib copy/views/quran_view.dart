import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quran_viewmodel.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuranViewModel()..fetchSurat(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Daftar Surat')),
        body: Consumer<QuranViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) return const Center(child: CircularProgressIndicator());
            return ListView.builder(
              itemCount: vm.suratList.length,
              itemBuilder: (context, index) {
                final surat = vm.suratList[index];
                return ListTile(
                  title: Text('${surat.arabName} - ${surat.name}'),
                  subtitle: Text('Ayat: ${surat.ayatCount}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
