class Bikes {
  final int id;
  final String brand;
  final String model;
  final String imageUrl;
  final double pricePerHour;

  Bikes({
    required this.id,
    required this.brand,
    required this.model,
    required this.imageUrl,
    required this.pricePerHour,
  });

  factory Bikes.fromJson(Map<String, dynamic> json) {
    return Bikes(
      id: int.parse(json['id'].toString()),
      brand: json['brand'].toString(),
      model: json['model'].toString(),
      imageUrl: json['imageUrl'].toString(),
      pricePerHour: double.tryParse(json['pricePerHour'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'imageUrl': imageUrl,
      'pricePerHour': pricePerHour,
    };
  }
}
