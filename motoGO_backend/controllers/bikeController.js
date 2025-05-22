const db = require('../models/db');

exports.getBikes = async (req, res) => {
  try {
    const [bikes] = await db.execute('SELECT * FROM bikes');
    res.json(bikes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.addBikes = async (req, res) => {
  const { brand, model, pricePerHour, imageUrl, status } = req.body;

  if (!brand || !model || !pricePerHour) {
    return res.status(400).json({ message: 'Brand, model, and pricePerHour required.' });
  }

  try {
    const query = 'INSERT INTO bikes (brand, model, pricePerHour, imageUrl, status) VALUES (?, ?, ?, ?, ?)';
    const [result] = await db.execute(query, [
      brand,
      model,
      pricePerHour,
      imageUrl || '',
      status || 'available',
    ]);

    res.status(201).json({
      id: result.insertId,
      brand,
      model,
      pricePerHour,
      imageUrl: imageUrl || '',
      status: status || 'available',
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
