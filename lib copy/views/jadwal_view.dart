import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/jadwal_viewmodel.dart';

class JadwalView extends StatelessWidget {
  const JadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JadwalViewModel()..fetchJadwal(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Jadwal Shalat')),
        body: Consumer<JadwalViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: vm.jadwalList.length,
              itemBuilder: (context, index) {
                final j = vm.jadwalList[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(j.tanggal),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subuh   : ${j.subuh}'),
                        Text('Dzuhur  : ${j.dzuhur}'),
                        Text('Ashar   : ${j.ashar}'),
                        Text('Maghrib : ${j.maghrib}'),
                        Text('Isya    : ${j.isya}'),
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
