const db = require('../models/db');

exports.getBikes = async (req, res) => {
  try {
    const [bikes] = await db.execute('SELECT * FROM bikes');
    res.json(bikes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
