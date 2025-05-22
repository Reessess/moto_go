class Bike {
  final int id;
  final String model;
  final String brand;
  final String description;
  final double pricePerDay;
  final String imageUrl;
  final String status;

  Bike({
    required this.id,
    required this.model,
    required this.brand,
    required this.description,
    required this.pricePerDay,
    required this.imageUrl,
    required this.status,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'],
      model: json['model'],
      brand: json['brand'],
      description: json['description'],
      pricePerDay: double.parse(json['price_per_day'].toString()),
      imageUrl: json['image_url'],
      status: json['status'],
    );
  }
}
