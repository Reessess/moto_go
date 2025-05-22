class Bikes {
  final int id;
  final String model;
  final String brand;
  final String description;
  final double pricePerHour;
  final String imageUrl;
  final String status;

  Bikes({
    required this.id,
    required this.model,
    required this.brand,
    required this.description,
    required this.pricePerHour,
    required this.imageUrl,
    required this.status,
  });

  factory Bikes.fromJson(Map<String, dynamic> json) {
    return Bikes(
      id: json['id'],
      model: json['model'],
      brand: json['brand'],
      description: json['description'],
      pricePerHour: double.parse(json['pricePerHour'].toString()),
      imageUrl: json['imageUrl'],
      status: json['status'],
    );
  }
}
