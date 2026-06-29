const db = require('../config/db');

exports.logActivity = (modulName) => {
    return async (req, res, next) => {
        // Kita biarkan proses utama (controller) berjalan dulu menggunakan event listener 'finish'
        res.on('finish', async () => {
            try {
                // Hanya catat jika proses berhasil (status 200 atau 201)
                if (res.statusCode === 200 || res.statusCode === 201) {
                    const userId = req.user ? req.user.id : null;
                    const ip = req.ip || req.connection.remoteAddress;
                    const ua = req.headers['user-agent'] || 'Unknown';
                    const url = req.originalUrl;
                    
                    // Terjemahkan HTTP Method menjadi Aksi CRUD
                    let aksi = 'Membaca'; // default GET
                    if (req.method === 'POST') aksi = 'Membuat';
                    if (req.method === 'PUT' || req.method === 'PATCH') aksi = 'Memperbarui';
                    if (req.method === 'DELETE') aksi = 'Menghapus';
                    
                    // Khusus untuk endpoint login
                    if (url.includes('/login')) aksi = 'Login ke aplikasi';

                    const title = `Akses Modul: ${modulName}`;
                    const content = `User melakukan aksi ${aksi} pada modul ${modulName}.`;

                    // Simpan ke tabel activities
                    await db.query(
                        `INSERT INTO activities (title, content, ua, ip, url, created_at, created_by) 
                         VALUES (?, ?, ?, ?, ?, NOW(), ?)`,
                        [title, content, ua, ip, url, userId]
                    );
                }
            } catch (error) {
                console.error('Gagal mencatat log aktivitas:', error);
            }
        });
        
        next(); // Lanjutkan ke proses selanjutnya
    };
};