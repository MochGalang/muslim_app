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
