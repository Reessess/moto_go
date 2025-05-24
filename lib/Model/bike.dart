class Bikes {
  final String id;
  final String brand;
  final String model;
  final String imageUrl;
  final double pricePerHour;
  final String status; // New field for status

  Bikes({
    required this.id,
    required this.brand,
    required this.model,
    required this.imageUrl,
    required this.pricePerHour,
    required this.status, // Include status in the constructor
  });

  factory Bikes.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic value) {
      try {
        return int.parse(value.toString());
      } catch (_) {
        return 0; // fallback id
      }
    }

    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return Bikes(
      id: json['id'].toString(),
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      pricePerHour: parsePrice(json['pricePerHour']),
      status: json['status']?.toString() ?? 'unavailable', // Default to 'unavailable' if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'imageUrl': imageUrl,
      'pricePerHour': pricePerHour,
      'status': status, // Include status in the JSON output
    };
  }
}