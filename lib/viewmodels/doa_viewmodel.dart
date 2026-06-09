import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/doa_model.dart';

class DoaViewModel extends ChangeNotifier {
  List<Doa> doaList = [];
  bool isLoading = false;

  Future<void> fetchDoa() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://equran.id/api/doa');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List data = responseData['data'] ?? [];
      doaList = data.map((json) => Doa.fromJson(json as Map<String, dynamic>)).toList();
    }

    isLoading = false;
    notifyListeners();
  }
}