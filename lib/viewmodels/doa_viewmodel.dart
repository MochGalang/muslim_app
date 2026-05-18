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

    final url = Uri.parse('https://doa-doa-api-ahmadramadhan.fly.dev/api');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      doaList = data.map((json) => Doa.fromJson(json)).toList();
    }

    isLoading = false;
    notifyListeners();
  }
}