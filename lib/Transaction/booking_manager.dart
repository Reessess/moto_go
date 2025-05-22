class BookingManager {
  static final List<Map<String, dynamic>> confirmedBookings = [];

  static void addBooking(Map<String, dynamic> booking) {
    confirmedBookings.add(booking);
  }

  static void removeBooking(int index) {
    confirmedBookings.removeAt(index);
  }
}
