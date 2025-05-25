const express = require('express');
const router = express.Router();
const {
  createPayment,
  getAllPayments,
  getPaymentById
} = require('../controllers/paymentController');

// POST /api/payments - Create a new payment
router.post('/', createPayment);

// GET /api/payments - Retrieve all payments
router.get('/', getAllPayments);

// GET /api/payments/:id - Retrieve a payment by ID
router.get('/:id', getPaymentById);

module.exports = router;
