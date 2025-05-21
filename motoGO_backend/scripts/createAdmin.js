const bcrypt = require('bcryptjs');
const db = require('../models/db'); // adjust path if needed

async function insertAdmin() {
  const username = 'motogo';
  const password = '1234'; // You can change this
  const hashed = await bcrypt.hash(password, 10);

  try {
    await db.query(
      'INSERT INTO admin_users (username, password) VALUES (?, ?)',
      [username, hashed]
    );
    console.log('✅ Admin user inserted!');
    process.exit();
  } catch (err) {
    console.error('❌ Error inserting admin user:', err);
    process.exit(1);
  }
}

insertAdmin();
