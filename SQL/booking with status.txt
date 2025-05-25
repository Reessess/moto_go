const db = require('../models/db');

// Create a new payment
const createPayment = async (req, res) => {
  try {
    const {
      bookingId,
      userId,
      method,
      accountName,
      accountNumber,
      referenceNumber,
      amount
    } = req.body;

    // Validate required fields
    if (
      !bookingId ||
      !userId ||
      !method ||
      !accountName ||
      !accountNumber ||
      !referenceNumber ||
      !amount
    ) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Insert the payment into the payments table
    const insertPaymentSql = `
      INSERT INTO payments (
        booking_id,
        user_id,
        method,
        account_name,
        account_number,
        reference_number,
        amount
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
    `;

    await db.query(insertPaymentSql, [
      bookingId,
      userId,
      method,
      accountName,
      accountNumber,
      referenceNumber,
      amount
    ]);

    // Update the booking status to 'Paid'
    const updateBookingStatusSql = `
      UPDATE bookings
      SET status = 'Paid'
      WHERE id = ?
    `;

    await db.query(updateBookingStatusSql, [bookingId]);

    // Send success response
    res.status(201).send('Payment Successful');
  } catch (error) {
    console.error('Error creating payment:', error);
    res.status(500).send('payment failed');
  }
};

// Retrieve all payments
const getAllPayments = async (req, res) => {
  try {
    const sql = 'SELECT * FROM payments';
    const payments = await db.query(sql);
    res.status(200).json(payments);
  } catch (error) {
    console.error('Error retrieving payments:', error);
    res.status(500).json({ error: 'Failed to retrieve payments' });
  }
};

// Retrieve a payment by ID
const getPaymentById = async (req, res) => {
  const { id } = req.params;

  try {
    const sql = 'SELECT * FROM payments WHERE id = ?';
    const payment = await db.query(sql, [id]);

    if (payment.length === 0) {
      return res.status(404).json({ error: 'Payment not found' });
    }

    res.status(200).json(payment[0]);
  } catch (error) {
    console.error('Error retrieving payment:', error);
    res.status(500).json({ error: 'Failed to retrieve payment' });
  }
};

module.exports = {
  createPayment,
  getAllPayments,
  getPaymentById
};
