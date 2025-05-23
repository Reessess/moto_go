class Booking {
  final int bikeId;
  final int userId;
  final DateTime pickupDateTime;
  final int hours;
  final double totalCost;

  Booking({
    required this.bikeId,
    required this.userId,
    required this.pickupDateTime,
    required this.hours,
    required this.totalCost,
  });

  // Convert Booking instance to JSON map for API
  Map<String, dynamic> toJson() {
    return {
      'bike_id': bikeId,
      'user_id': userId,
      'pickup_datetime': pickupDateTime.toIso8601String(),
      'hours': hours,
      'total_cost': totalCost,
    };
  }

  // Create Booking instance from JSON map (e.g. from API response)
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bikeId: json['bike_id'],
      userId: json['user_id'],
      pickupDateTime: DateTime.parse(json['pickup_datetime']),
      hours: json['hours'],
      totalCost: (json['total_cost'] as num).toDouble(),
    );
  }
}
