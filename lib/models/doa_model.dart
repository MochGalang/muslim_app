class Doa {
  final String title;
  final String arab;
  final String latin;
  final String translation;

  Doa({
    required this.title,
    required this.arab,
    required this.latin,
    required this.translation,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      title: json['nama'] ?? json['doa'] ?? '',
      arab: json['ar'] ?? json['ayat'] ?? '',
      latin: json['tr'] ?? json['latin'] ?? '',
      translation: json['idn'] ?? json['artinya'] ?? '',
    );
  }
}
