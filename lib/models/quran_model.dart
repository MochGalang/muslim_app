class QuranSurat {
  final int number;
  final String name;
  final String arabName;
  final int ayatCount;

  QuranSurat({
    required this.number,
    required this.name,
    required this.arabName,
    required this.ayatCount,
  });

  factory QuranSurat.fromJson(Map<String, dynamic> json) {
    return QuranSurat(
      number: json['nomor'] ?? 0,
      name: json['nama'] ?? '',
      arabName: json['namaLatin'] ?? '',
      ayatCount: json['jumlahAyat'] ?? 0,
    );
  }
}

class QuranAyat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  QuranAyat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory QuranAyat.fromJson(Map<String, dynamic> json) {
    return QuranAyat(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
    );
  }
}
