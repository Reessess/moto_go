const db = require('../models/db');

exports.createBooking = async (req, res) => {
  const { user_id, bike_id, hours, pickup_time, payment_method, total_price } = req.body;
  try {
    await db.execute(
      'INSERT INTO bookings (user_id, bike_id, hours, pickup_time, payment_method, total_price) VALUES (?, ?, ?, ?, ?, ?)',
      [user_id, bike_id, hours, pickup_time, payment_method, total_price]
    );
    res.status(201).json({ message: 'Booking successful' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
