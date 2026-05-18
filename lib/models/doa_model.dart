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
      title: json['doa'],
      arab: json['ayat'],
      latin: json['latin'],
      translation: json['artinya'],
    );
  }
}
