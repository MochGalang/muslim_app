import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/doa_viewmodel.dart';

class DoaView extends StatelessWidget {
  const DoaView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoaViewModel()..fetchDoa(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Doa Harian')),
        body: Consumer<DoaViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) return const Center(child: CircularProgressIndicator());
            return ListView.builder(
              itemCount: vm.doaList.length,
              itemBuilder: (context, index) {
                final doa = vm.doaList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doa.title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(doa.arab, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(doa.latin),
                        const SizedBox(height: 4),
                        Text(doa.translation),
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
