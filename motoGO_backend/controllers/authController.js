const db = require('../models/db');
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
    // Query admin user by username
    const [rows] = await db.query('SELECT * FROM admin_users WHERE username = ?', [username]);

    if (!rows || rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password',
      });
    }

    const admin = rows[0];

    // Compare password using bcrypt
    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password',
      });
    }

    // Login successful
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
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

// User Registration Handler
exports.register = async (req, res) => {
  const {
    first_name,
    middle_name,
    last_name,
    username,
    email,
    phone,
    dob,
    password,
  } = req.body;

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

// User Login Handler (added)
exports.userLogin = async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: 'Username and password are required',
    });
  }

  try {
    // Query user by username
    const [rows] = await db.query('SELECT * FROM users WHERE username = ?', [username]);

    if (!rows || rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password',
      });
    }

    const user = rows[0];

    // Compare password using bcrypt
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password',
      });
    }

    // Login successful
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
