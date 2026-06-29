const mysql = require('mysql2/promise');
require('dotenv').config();

const dbPool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Tes koneksi saat aplikasi berjalan
dbPool.getConnection()
  .then((conn) => {
    console.log('Koneksi ke database  db_pegawai berhasil!');
    conn.release();
  })
  .catch((err) => {
    console.error('Gagal terkoneksi ke database:', err.message);
  });

module.exports = dbPool;