const mysql = require('mysql2/promise');
require('dotenv').config();

// DB_SSL=true diperlukan untuk database cloud seperti MariaDB SkySQL, yang
// mewajibkan koneksi terenkripsi. Untuk development lokal (XAMPP/Laragon),
// biarkan DB_SSL kosong/false karena MariaDB lokal biasanya tidak pakai SSL.
const useSSL = process.env.DB_SSL === 'true';

const dbPool = mysql.createPool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 4043, // SkySQL biasanya pakai port khusus (cek dashboard SkySQL kamu), bukan 3306 default
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ...(useSSL ? {
    ssl: {
      // rejectUnauthorized: false cukup untuk kebanyakan kasus tanpa perlu
      // mengunduh/menyimpan file CA certificate secara manual. Untuk keamanan
      // produksi yang lebih ketat, idealnya pakai CA cert resmi dari SkySQL.
      rejectUnauthorized: false
    }
  } : {})
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