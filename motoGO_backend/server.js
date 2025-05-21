const express = require('express');
const dotenv = require('dotenv');
const db = require('./models/db');
const authRoutes = require('./routes/authRoutes');

dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);

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

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
