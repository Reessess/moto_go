const express = require('express');
const dotenv = require('dotenv');
const db = require('./models/db');
const authRoutes = require('./routes/authRoutes');
const bikeRoutes = require('./routes/bikeRoutes');
const cors = require('cors');
dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/bikes', bikeRoutes);
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
