// routes/bookingRoutes.js
const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');
console.log('bookingController:', bookingController);


// Create a booking
router.post('/', bookingController.createBooking);

// Get all bookings
router.get('/', bookingController.getAllBookings);

router.get('/:userId', bookingController.getBookingsByUser);

// In bookingRoutes.js
router.delete('/:id', bookingController.cancelBooking);


module.exports = router;
