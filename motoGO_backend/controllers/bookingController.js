// controllers/bookingController.js

const db = require('../models/db'); // Reuse shared DB connection

// Create a booking
exports.createBooking = (req, res) => {
    const { bike_id, user_id, pickup_datetime, hours, total_cost } = req.body;

    if (!bike_id || !user_id || !pickup_datetime || !hours || !total_cost) {
        return res.status(400).json({ error: 'All fields are required.' });
    }

    const sql = 'INSERT INTO bookings (bike_id, user_id, pickup_datetime, hours, total_cost) VALUES (?, ?, ?, ?, ?)';
    const values = [bike_id, user_id, pickup_datetime, hours, total_cost];

    db.query(sql, values, (err, result) => {
        if (err) {
            console.error('Error inserting booking:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(201).json({ message: 'Booking created', bookingId: result.insertId });
    });
};

// Get all bookings
exports.getAllBookings = (req, res) => {
    const sql = 'SELECT * FROM bookings';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching bookings:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(200).json(results);
    });
};
