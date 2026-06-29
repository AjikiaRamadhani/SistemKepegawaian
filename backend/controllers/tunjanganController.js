const db = require('../config/db');

// --- FITUR HITUNG TUNJANGAN ---
exports.hitungTunjangan = async (req, res) => {
    const conn = await db.getConnection();
    try {
        const { bulan, tahun, kehadiran } = req.body;
        if (!bulan || !tahun || !kehadiran || !Array.isArray(kehadiran)) {
            return res.status(400).json({ message: 'Data input tidak lengkap' });
        }

        // Nama tabel sesuai database (setting_tunjangan)
        const [setting] = await conn.query('SELECT * FROM setting_tunjangan ORDER BY id DESC LIMIT 1');
        if (setting.length === 0) {
            return res.status(400).json({ message: 'Setting tunjangan belum diatur' });
        }
        
        const { base_fare, min_km, max_km } = setting[0];

        await conn.beginTransaction();

        let totalPenerima = 0;
        let totalNominalBulanan = 0;
        let detailTunjangan = [];

        for (const data of kehadiran) {
            const { id_pegawai, jumlah_hari } = data;
            const [pegawaiData] = await conn.query('SELECT nama_pegawai, status_kontrak, jarak_rumah_kantor FROM pegawai WHERE id = ?', [id_pegawai]);
            
            if (pegawaiData.length === 0) continue;
            const pegawai = pegawaiData[0];

            if (pegawai.status_kontrak !== 'PKWTT' || jumlah_hari < 19) continue;

            let jarak = parseFloat(pegawai.jarak_rumah_kantor || 0);
            // Jarak 5 km atau kurang (<=) tidak dihitung tunjangan
            if (jarak <= min_km) continue;
            if (jarak > max_km) jarak = max_km;

            const jarakBulat = Math.round(jarak);
            const nominalTunjangan = base_fare * jarakBulat * jumlah_hari;

            totalPenerima++;
            totalNominalBulanan += nominalTunjangan;
            detailTunjangan.push([id_pegawai, jarakBulat, jumlah_hari, nominalTunjangan]);
        }

        const [resultBulanan] = await conn.query(
            'INSERT INTO tunjangan_bulanan (bulan, tahun, total_penerima, total_nominal) VALUES (?, ?, ?, ?)',
            [bulan, tahun, totalPenerima, totalNominalBulanan]
        );

        if (detailTunjangan.length > 0) {
            const valuesToInsert = detailTunjangan.map(d => [resultBulanan.insertId, ...d]);
            await conn.query('INSERT INTO tunjangan_detail (id_tunjangan_bulanan, id_pegawai, jarak_km, jumlah_hari, nominal) VALUES ?', [valuesToInsert]);
        }

        await conn.commit();
        res.status(201).json({ message: 'Berhasil', data: { total_penerima: totalPenerima, total_nominal: totalNominalBulanan }});
    } catch (error) {
        await conn.rollback();
        console.error(error);
        res.status(500).json({ message: 'Server Error' });
    } finally {
        conn.release();
    }
};

// --- FITUR SETTING ---
exports.getSetting = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM setting_tunjangan LIMIT 1');
        res.json({ data: rows[0] });
    } catch (e) { res.status(500).json({ message: 'Error' }); }
};

exports.updateSetting = async (req, res) => {
    try {
        const { base_fare, berlaku_mulai, min_km, max_km } = req.body;
        await db.query('UPDATE setting_tunjangan SET base_fare=?, berlaku_mulai=?, min_km=?, max_km=? WHERE id=1', [base_fare, berlaku_mulai, min_km, max_km]);
        res.json({ message: 'Update berhasil' });
    } catch (e) { res.status(500).json({ message: 'Error' }); }
};

// --- FITUR RIWAYAT ---
exports.getRiwayatTunjangan = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM tunjangan_bulanan ORDER BY id DESC');
        res.json({ data: rows });
    } catch (e) { res.status(500).json({ message: 'Error' }); }
};

exports.getDetailTunjangan = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT d.*, p.nama_pegawai FROM tunjangan_detail d JOIN pegawai p ON d.id_pegawai=p.id WHERE d.id_tunjangan_bulanan = ?', [req.params.id_bulanan]);
        res.json({ data: rows });
    } catch (e) { res.status(500).json({ message: 'Error' }); }
};

// --- CEK STATUS BULAN: sudah dihitung atau belum ---
// Dipakai oleh halaman detail (/tunjangan/transport/detail/[bulan]/[tahun]) untuk
// memutuskan: tampilkan hasil yang sudah ada, atau tampilkan form input kehadiran.
exports.cekStatusBulan = async (req, res) => {
    try {
        const { bulan, tahun } = req.params;

        const [existing] = await db.query(
            'SELECT * FROM tunjangan_bulanan WHERE bulan = ? AND tahun = ? LIMIT 1',
            [bulan, tahun]
        );

        if (existing.length > 0) {
            // Sudah pernah dihitung -> langsung kembalikan detailnya juga
            const [detail] = await db.query(
                'SELECT d.*, p.nama_pegawai FROM tunjangan_detail d JOIN pegawai p ON d.id_pegawai=p.id WHERE d.id_tunjangan_bulanan = ?',
                [existing[0].id]
            );
            return res.json({
                sudah_dihitung: true,
                bulanan: existing[0],
                detail
            });
        }

        // Belum pernah dihitung -> kembalikan daftar pegawai PKWTT yang
        // berhak menerima tunjangan, agar HRD bisa input jumlah hari kerja
        const [pegawaiPKWTT] = await db.query(
            "SELECT id, nip, nama_pegawai, jarak_rumah_kantor FROM pegawai WHERE status_kontrak = 'PKWTT' AND status = 'Aktif'"
        );

        res.json({
            sudah_dihitung: false,
            pegawai: pegawaiPKWTT
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal memeriksa status bulan' });
    }
};