import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quran_model.dart';

class QuranViewModel extends ChangeNotifier {
  List<QuranSurat> suratList = [];
  bool isLoading = false;

  List<QuranAyat> ayatList = [];
  bool isLoadingDetail = false;

  Future<void> fetchSurat() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://equran.id/api/v2/surat');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      suratList = data.map((json) => QuranSurat.fromJson(json)).toList();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDetailSurat(int nomorSurat) async {
    isLoadingDetail = true;
    notifyListeners();

    final url = Uri.parse('https://equran.id/api/v2/surat/$nomorSurat');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final List listAyat = data['ayat'];
      ayatList = listAyat.map((json) => QuranAyat.fromJson(json)).toList();
    } else {
      ayatList = [];
    }

    isLoadingDetail = false;
    notifyListeners();
  }
}
