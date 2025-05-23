// routes/bookingRoutes.js
const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');

// Define the route for creating a booking
router.post('/', bookingController.createBooking);

// GET: Retrieve all bookings
router.get('/', bookingController.getAllBookings);

module.exports = router;
