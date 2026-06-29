const db = require('../config/db');

exports.getDashboard = async (req, res) => {
    try {
        const userRole = req.user.role; // Didapat dari token JWT di middleware

        // Jika yang login adalah Manager HRD, hitung statistik dari database
        if (userRole === 'Manager HRD') {
            const [[totalPegawai]] = await db.query('SELECT COUNT(*) as total FROM pegawai');
            const [[totalPKWT]] = await db.query('SELECT COUNT(*) as total FROM pegawai WHERE status_kontrak = "PKWT"');
            const [[totalPKWTT]] = await db.query('SELECT COUNT(*) as total FROM pegawai WHERE status_kontrak = "PKWTT"');
            const [[totalMagang]] = await db.query('SELECT COUNT(*) as total FROM pegawai WHERE status_kontrak = "Magang"');

            const [[totalPria]] = await db.query('SELECT COUNT(*) as total FROM pegawai WHERE jenis_kelamin = "Pria"');
            const [[totalWanita]] = await db.query('SELECT COUNT(*) as total FROM pegawai WHERE jenis_kelamin = "Wanita"');

            // Ambil 5 pegawai terbaru (sertakan id agar link "Detail Pegawai" di frontend bisa jalan)
            const [pegawaiTerbaru] = await db.query('SELECT id, nip, nama_pegawai, tanggal_masuk, status_kontrak FROM pegawai ORDER BY tanggal_masuk DESC LIMIT 5');

            return res.json({
                role: userRole,
                widgets: {
                    total_pegawai: totalPegawai.total,
                    total_kontrak: totalPKWT.total,
                    total_tetap: totalPKWTT.total,
                    total_magang: totalMagang.total
                },
                charts: {
                    kontrak_vs_tetap_vs_magang: [totalPKWT.total, totalPKWTT.total, totalMagang.total],
                    pria_vs_wanita: [totalPria.total, totalWanita.total]
                },
                recent_employees: pegawaiTerbaru
            });
        }

        // Jika yang login adalah Superadmin atau Admin HRD, kembalikan pesan standar
        res.json({ 
            role: userRole, 
            message: `Selamat Datang di Dashboard - ${userRole}` 
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Terjadi kesalahan saat memuat dashboard' });
    }
};