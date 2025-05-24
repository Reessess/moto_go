class Booking {
  final int id;
  final int bikeId;
  final int userId;
  final DateTime pickupDateTime;
  final int hours;
  final double totalCost;
  final String bikeBrand;
  final String bikeModel;
  final double pricePerHour;

  Booking({
    required this.id,
    required this.bikeId,
    required this.userId,
    required this.pickupDateTime,
    required this.hours,
    required this.totalCost,
    required this.bikeBrand,
    required this.bikeModel,
    required this.pricePerHour,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: (json['id'] is String) ? int.parse(json['id']) : json['id'],
      bikeId: (json['bike_id'] is String) ? int.parse(json['bike_id']) : json['bike_id'],
      userId: (json['user_id'] is String) ? int.parse(json['user_id']) : json['user_id'],
      pickupDateTime: DateTime.parse(json['pickup_datetime']),
      hours: (json['hours'] is String) ? int.parse(json['hours']) : json['hours'],
      totalCost: (json['total_cost'] is String)
          ? double.parse(json['total_cost'])
          : (json['total_cost'] as num).toDouble(),
      bikeBrand: json['brand'],
      bikeModel: json['model'],
      pricePerHour: (json['pricePerHour'] is String)
          ? double.parse(json['pricePerHour'])
          : (json['pricePerHour'] as num).toDouble(),
    );
  }
}
