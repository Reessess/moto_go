class Booking {
  final String bikeLabel;
  final String bikeImage;
  final int pricePerHour;
  final DateTime bookingDate;
  final int hoursBooked;

  Booking({
    required this.bikeLabel,
    required this.bikeImage,
    required this.pricePerHour,
    required this.bookingDate,
    required this.hoursBooked,
  });
}
