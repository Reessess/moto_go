// controllers/bookingController.js

const db = require('../models/db'); // promise-based pool

// Create a booking
exports.createBooking = async (req, res) => {
  const { bike_id, user_id, pickup_datetime, hours, total_cost } = req.body;

  if (!bike_id || !user_id || !pickup_datetime || !hours || !total_cost) {
    return res.status(400).json({ error: 'All fields are required.' });
  }

  const sql = 'INSERT INTO bookings (bike_id, user_id, pickup_datetime, hours, total_cost) VALUES (?, ?, ?, ?, ?)';
  const values = [bike_id, user_id, pickup_datetime, hours, total_cost];

  try {
    const [result] = await db.query(sql, values);
    res.status(201).json({ message: 'Booking created', bookingId: result.insertId });
  } catch (err) {
    console.error('Error inserting booking:', err);
    res.status(500).json({ error: 'Database error' });
  }
};

// Get all bookings with user and bike details
exports.getAllBookings = async (req, res) => {
  const sql = `
    SELECT
      bookings.*,
      users.username, users.email, users.first_name, users.last_name,
      bikes.brand, bikes.model, bikes.pricePerHour
    FROM bookings
    JOIN users ON bookings.user_id = users.id
    JOIN bikes ON bookings.bike_id = bikes.id
  `;

  try {
    const [results] = await db.query(sql);
    res.status(200).json(results);
  } catch (err) {
    console.error('Error fetching bookings:', err);
    res.status(500).json({ error: 'Database error' });
  }
};

// Get bookings filtered by user ID
exports.getBookingsByUser = async (req, res) => {
  const userId = req.params.userId;

  const sql = `
    SELECT
      bookings.*,
      users.username, users.email, users.first_name, users.last_name,
      bikes.brand, bikes.model, bikes.pricePerHour
    FROM bookings
    JOIN users ON bookings.user_id = users.id
    JOIN bikes ON bookings.bike_id = bikes.id
    WHERE bookings.user_id = ?
  `;

  try {
    const [results] = await db.query(sql, [userId]);
    res.status(200).json(results);
  } catch (err) {
    console.error('Error fetching user bookings:', err);
    res.status(500).json({ error: 'Database error' });
  }
};
// In bookingController.js
exports.cancelBooking = async (req, res) => {
  const bookingId = req.params.id;
  try {
    await db.query('DELETE FROM bookings WHERE id = ?', [bookingId]);
    res.status(200).json({ message: 'Booking cancelled successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to cancel booking' });
  }
};

