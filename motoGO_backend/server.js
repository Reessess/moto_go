const express = require('express');
const dotenv = require('dotenv');
const db = require('./models/db');
const authRoutes = require('./routes/authRoutes');
const bikeRoutes = require('./routes/bikeRoutes');
const bookingRoutes = require('./routes/bookingRoutes');
const paymentRoutes = require('./routes/paymentRoutes');

const cors = require('cors');
dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
// Use Bikes routes
app.use('/api/bikes', bikeRoutes);
// Use booking routes
app.use('/api/bookings', bookingRoutes);
// Use payment routes
app.use('/api/payments', paymentRoutes);

// DB connection test
app.get('/test-db', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT 1 + 1 AS solution');
    res.json({ result: rows[0].solution });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Database query failed' });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${PORT}`);
});
