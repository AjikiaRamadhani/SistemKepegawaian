const bcrypt = require('bcrypt');
const db = require('../config/db');

// Validasi password sesuai aturan pembuatan user baru di soal:
// minimal 8 karakter, tanpa spasi, minimal 1 huruf besar, 1 huruf kecil, 1 karakter khusus
const PASSWORD_RULE = /^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>])(?!.*\s).{8,}$/;

// GET: Mengambil data profil milik user yang sedang login (Read Own)
exports.getMyProfile = async (req, res) => {
    try {
        const userId = req.user.id;

        const [rows] = await db.query(`
            SELECT 
                u.id, u.username, u.nama, u.email, u.last_login, u.created_at,
                r.nama_role,
                p.nip, p.jenis_kelamin, p.tanggal_masuk,
                m.nama AS nama_jabatan,
                d.nama_departemen
            FROM user u
            LEFT JOIN user_role r ON u.id_role = r.id
            LEFT JOIN pegawai p ON u.id_pegawai = p.id
            LEFT JOIN master_data m ON p.id_jabatan = m.id AND m.tipe = 'jabatan'
            LEFT JOIN departemen d ON p.id_departemen = d.id
            WHERE u.id = ?
        `, [userId]);

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Profil tidak ditemukan' });
        }

        res.json({ data: rows[0] });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil data profil' });
    }
};

// PUT: Memperbarui profil milik sendiri (Update Own) -- email dan/atau password
// Sesuai soal: password diperbarui mandiri oleh user lewat halaman profilnya,
// dengan aturan yang sama seperti pembuatan password user baru.
exports.updateMyProfile = async (req, res) => {
    try {
        const userId = req.user.id;
        const { email, current_password, new_password } = req.body;

        const [rows] = await db.query('SELECT password_hash FROM user WHERE id = ?', [userId]);
        if (rows.length === 0) {
            return res.status(404).json({ message: 'User tidak ditemukan' });
        }

        const updates = [];
        const params = [];

        // --- UPDATE EMAIL (opsional) ---
        if (email && email.trim() !== '') {
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                return res.status(400).json({ message: 'Format email tidak valid' });
            }
            updates.push('email = ?');
            params.push(email.trim());
        }

        // --- UPDATE PASSWORD (opsional, tapi butuh current_password & new_password sekaligus) ---
        if (new_password) {
            if (!current_password) {
                return res.status(400).json({ message: 'Password saat ini wajib diisi untuk mengganti password' });
            }

            const isMatch = await bcrypt.compare(current_password, rows[0].password_hash);
            if (!isMatch) {
                return res.status(400).json({ message: 'Password saat ini tidak sesuai' });
            }

            if (!PASSWORD_RULE.test(new_password)) {
                return res.status(400).json({
                    message: 'Password baru tidak valid. Minimal 8 karakter, tanpa spasi, harus ada huruf besar, huruf kecil, dan karakter khusus.'
                });
            }

            const newHash = await bcrypt.hash(new_password, 10);
            updates.push('password_hash = ?');
            params.push(newHash);
        }

        if (updates.length === 0) {
            return res.status(400).json({ message: 'Tidak ada data yang diperbarui' });
        }

        params.push(userId);
        await db.query(`UPDATE user SET ${updates.join(', ')} WHERE id = ?`, params);

        res.json({ message: 'Profil berhasil diperbarui' });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ message: 'Email sudah digunakan oleh akun lain' });
        }
        console.error(error);
        res.status(500).json({ message: 'Gagal memperbarui profil' });
    }
};