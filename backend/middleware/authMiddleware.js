const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.verifyToken = (req, res, next) => {
    // Mengambil token dari header request (biasanya formatnya: "Bearer <token>")
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    // Kalau tidak ada token sama sekali
    if (!token) {
        return res.status(401).json({ message: 'Akses ditolak. Token tidak ditemukan.' });
    }

    // Verifikasi keaslian token menggunakan JWT_SECRET dari file .env
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(403).json({ message: 'Sesi telah berakhir atau token tidak valid. Silakan login kembali.' });
        }
        
        // Kalau token asli, simpan data user (id dan role) ke dalam request agar bisa dipakai oleh controller
        req.user = decoded; 
        next(); // Persilakan masuk ke proses selanjutnya
    });
};