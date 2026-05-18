import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/jadwal_model.dart';

class JadwalViewModel extends ChangeNotifier {
  List<JadwalShalat> jadwalList = [];
  bool isLoading = false;

  Future<void> fetchJadwal() async {
    isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://api.myquran.com/v2/sholat/jadwal/1206/2025/1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data']['jadwal'];

      jadwalList = list.map((item) => JadwalShalat.fromJson(item)).toList();
    }

    isLoading = false;
    notifyListeners();
  }
}
