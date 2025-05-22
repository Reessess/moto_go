const db = require('../models/db'); // your db connection (promise-based)
const bcrypt = require('bcryptjs');

// Admin Login Handler
exports.adminLogin = async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: 'Username and password are required',
    });
  }

  try {
    const [rows] = await db.query('SELECT * FROM admin_users WHERE username = ?', [username]);
    if (!rows.length) {
      return res.status(401).json({ success: false, message: 'Invalid username or password' });
    }

    const admin = rows[0];
    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid username or password' });
    }

    return res.status(200).json({
      success: true,
      message: 'Login successful',
      admin: {
        id: admin.id,
        username: admin.username,
        email: admin.email || null,
      },
    });
  } catch (error) {
    console.error('Admin login error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// User Registration Handler
exports.register = async (req, res) => {
  const { first_name, middle_name, last_name, username, email, phone, dob, password } = req.body;

  if (!first_name || !last_name || !username || !email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Required fields are missing',
    });
  }

  try {
    const [existingUser] = await db.query(
      'SELECT * FROM users WHERE username = ? OR email = ?',
      [username, email]
    );

    if (existingUser.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Username or email already exists',
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    await db.query(
      `INSERT INTO users
        (first_name, middle_name, last_name, username, email, phone, dob, password)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        first_name,
        middle_name || null,
        last_name,
        username,
        email,
        phone || null,
        dob || null,
        hashedPassword,
      ]
    );

    return res.status(201).json({
      success: true,
      message: 'User registered successfully',
    });
  } catch (err) {
    console.error('Registration error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error during registration',
    });
  }
};

// User Login Handler
exports.userLogin = async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: 'Username and password are required',
    });
  }

  try {
    const [rows] = await db.query('SELECT * FROM users WHERE username = ?', [username]);

    if (!rows.length) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password',
      });
    }

    const user = rows[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Login successful',
      user: {
        id: user.id,
        username: user.username,
        email: user.email || null,
      },
    });
  } catch (error) {
    console.error('User login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

// Get User Profile Handler
exports.getUserProfile = async (req, res) => {
  // I recommend using req.params or req.query based on your routing
  const username = req.query.username || req.params.username;

  if (!username) {
    return res.status(400).json({
      success: false,
      message: 'Username is required',
    });
  }

  try {
    const [rows] = await db.query(
      `SELECT first_name, middle_name, last_name, username, email, phone, dob
       FROM users
       WHERE username = ?`,
      [username]
    );

    if (!rows.length) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    return res.status(200).json({
      success: true,
      data: rows[0],
    });
  } catch (err) {
    console.error('Error fetching user profile:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};
exports.updateProfile = async (req, res) => {
  const { username, first_name, middle_name, last_name, email, phone, dob } = req.body;

  if (!username) {
    return res.status(400).json({
      success: false,
      message: 'Username is required',
    });
  }

  try {
    // Optional: Check if user exists first (not mandatory)
    const [existingUser] = await db.query('SELECT * FROM users WHERE username = ?', [username]);
    if (existingUser.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    const sql = `
      UPDATE users SET
        first_name = ?,
        middle_name = ?,
        last_name = ?,
        email = ?,
        phone = ?,
        dob = ?
      WHERE username = ?
    `;

    const params = [
      first_name || null,
      middle_name || null,
      last_name || null,
      email || null,
      phone || null,
      dob || null,
      username,
    ];

    const [result] = await db.query(sql, params);

    if (result.affectedRows === 0) {
      return res.status(400).json({
        success: false,
        message: 'Update failed',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
    });
  } catch (error) {
    console.error('Update profile error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while updating profile',
    });
  }
};
