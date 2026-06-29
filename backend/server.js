const express = require('express');
const cors = require('cors');
require('dotenv').config();
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');


const db = require('./config/db'); // Memanggil koneksi database
const authRoutes = require('./routes/authRoutes'); // Memanggil route auth
const dashboardRoutes = require('./routes/dashboardRoutes'); // Memanggil route dashboard
const pegawaiRoutes = require('./routes/pegawaiRoutes'); // Memanggil route pegawai
const tunjanganRoutes = require('./routes/tunjanganRoutes'); // Memanggil route tunjangan
const userRoutes = require('./routes/userRoutes'); // Memanggil route user
const roleRoutes = require('./routes/roleRoutes'); // Memanggil route role (Kelola Role)
const logRoutes = require('./routes/logRoutes'); // Memanggil route log (Modul Log)
const profileRoutes = require('./routes/profileRoutes'); // Memanggil route my profile

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors()); // Mengizinkan Nuxt untuk mengambil data
app.use(express.json()); // Membaca body request berbentuk JSON
app.use(express.urlencoded({ extended: true }));
app.use((req, res, next) => {
  if (req.url.startsWith('/_/backend')) {
    req.url = req.url.replace('/_/backend', '');
  }
  next();
});

// --- SETUP SWAGGER ---
const swaggerOptions = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'API Sistem Informasi Kepegawaian JMC',
      version: '1.0.0',
      description: 'Dokumentasi API Khusus Modul Perhitungan Tunjangan Transport',
    },
    servers: [{ url: `http://localhost:${PORT}` }],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [{ bearerAuth: [] }],
  },
  apis: ['./routes/*.js'], // Mencari dokumentasi di semua file routes
};
const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));
const mysql = require('mysql2'); // atau menyesuaikan library yang kamu pakai
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 4043, // Tambahkan baris port ini
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: {
    rejectUnauthorized: false // Wajib ditambah karena MariaDB Cloud mewajibkan SSL
  }
});

app.use('/api/auth', authRoutes); // Menggunakan route auth
app.use('/api/dashboard', dashboardRoutes); // Menggunakan route dashboard
app.use('/api/pegawai', pegawaiRoutes); // Menggunakan route pegawai
app.use('/api/tunjangan', tunjanganRoutes); // Menggunakan route tunjangan
app.use('/api/user', userRoutes); // Menggunakan route user
app.use('/api/role', roleRoutes); // Menggunakan route role (Kelola Role)
app.use('/api/log', logRoutes); // Menggunakan route log (Modul Log)
app.use('/api/profile', profileRoutes); // Menggunakan route my profile

// Route dasar untuk tes
app.get('/', (req, res) => {
  res.json({ message: 'Selamat datang di API Sistem Informasi Kepegawaian JMC' });
});

// Menyalakan server
// process.env.VERCEL diset otomatis oleh Vercel di lingkungan production-nya.
// Saat di Vercel, kita TIDAK perlu app.listen() karena Vercel sendiri yang
// menangani request masuk lewat serverless function (lihat api/index.js).
// app.listen() hanya dijalankan saat development lokal (npm run dev).
if (!process.env.VERCEL) {
  app.listen(PORT, () => {
    console.log(`Server backend berjalan di http://localhost:${PORT}`);
    console.log(`📄 Dokumentasi API Swagger tersedia di http://localhost:${PORT}/api-docs`);
  });
}

// Export Express app supaya bisa di-require oleh api/index.js sebagai
// serverless function handler di Vercel.
module.exports = app;