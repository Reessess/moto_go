const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: '127.0.0.1',
  user: 'motogo',           // your MySQL user
  password: '1234',  // your MySQL password
  database: 'motogo_db'    // your database name
});

module.exports = pool;
