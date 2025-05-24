const db = require('../models/db');

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

    if (!bookingId || !userId || !method || !accountName || !accountNumber || !referenceNumber || !amount) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const sql = `
      INSERT INTO payments (booking_id, user_id, method, account_name, account_number, reference_number, amount)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `;

    await db.query(sql, [
      bookingId,
      userId,
      method,
      accountName,
      accountNumber,
      referenceNumber,
      amount
    ]);

    res.status(200).json({ message: 'Payment recorded successfully' });
  } catch (error) {
    console.error('Error creating payment:', error);
    res.status(500).json({ error: 'Failed to create payment' });
  }
};

module.exports = { createPayment };
