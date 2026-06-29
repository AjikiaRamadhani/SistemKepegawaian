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
// ---------------------

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
app.listen(PORT, () => {
  console.log(`Server backend berjalan di http://localhost:${PORT}`);
  console.log(`📄 Dokumentasi API Swagger tersedia di http://localhost:${PORT}/api-docs`);
});

module.exports = app;