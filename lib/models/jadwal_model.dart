class JadwalShalat {
  final String tanggal;
  final String subuh;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  JadwalShalat({
    required this.tanggal,
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  factory JadwalShalat.fromJson(Map<String, dynamic> json) {
    return JadwalShalat(
      tanggal: json['tanggal'],
      subuh: json['subuh'],
      dzuhur: json['dzuhur'],
      ashar: json['ashar'],
      maghrib: json['maghrib'],
      isya: json['isya'],
    );
  }
}
