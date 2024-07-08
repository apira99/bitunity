class Fruit {
  final String name;
  final String vitamins;
  final String sugarContent;
  final String fiberContent;

  Fruit({
    required this.name,
    required this.vitamins,
    required this.sugarContent,
    required this.fiberContent,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      name: json['name'] ?? 'Unknown',
      vitamins: json['vitamins'] ?? 'No vitamins data',
      sugarContent: json['sugarContent'] ?? 'No sugar data',
      fiberContent: json['fiber'] ?? 'No fiber data', // Corrected to 'fiber' instead of 'fiberContent'
    );
  }
}
