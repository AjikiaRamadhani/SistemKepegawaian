const db = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

exports.login = async (req, res) => {
    try {
        // Menerima input dari user (ditambahkan expectedCaptcha dari frontend)
        const { identifier, password, captcha, expectedCaptcha, rememberMe } = req.body;

        // Validasi input kosong
        if (!identifier || !password) {
            return res.status(400).json({ message: 'Kredensial tidak boleh kosong' });
        }

        // VALIDASI CAPTCHA SEDERHANA (Menggantikan catatan Google API)
        if (!captcha) {
            return res.status(400).json({ message: 'Captcha tidak boleh kosong' });
        }
        if (captcha !== expectedCaptcha) {
            return res.status(400).json({ message: 'Kode Captcha salah' });
        }

        // Cari user berdasarkan username, email, atau nomor_hp (gabung tabel pegawai)
        const [users] = await db.query(`
            SELECT u.*, p.nomor_hp, r.nama_role 
            FROM user u 
            LEFT JOIN pegawai p ON u.id_pegawai = p.id
            LEFT JOIN user_role r ON u.id_role = r.id
            WHERE u.username = ? OR u.email = ? OR p.nomor_hp = ?
        `, [identifier, identifier, identifier]);

        if (users.length === 0) {
            return res.status(401).json({ message: 'Username/Email/No HP atau Password salah' });
        }

        const user = users[0];

        // Cek apakah akun dinonaktifkan (disabled = 1)
        if (user.disabled === 1) {
            return res.status(403).json({ message: 'Akun Anda dinonaktifkan, tidak dapat login' });
        }

        // Cocokkan password dengan hash di database
        const isMatch = await bcrypt.compare(password, user.password_hash);
        if (!isMatch) {
            return res.status(401).json({ message: 'Username/Email/No HP atau Password salah' });
        }

        // Buat Token JWT. Jika rememberMe dicentang, sesi lebih lama (misal 1 hari). 
        // Jika tidak, sesi hanya 3 menit sesuai aturan.
        // id_role disimpan di token agar middleware RBAC (checkPermission) bisa
        // langsung query ke tabel role_permission tanpa query tambahan.
        const expiresIn = rememberMe ? '1d' : '3m';
        const token = jwt.sign(
            { id: user.id, id_role: user.id_role, role: user.nama_role },
            process.env.JWT_SECRET,
            { expiresIn }
        );

        // Update waktu terakhir login
        await db.query('UPDATE user SET last_login = NOW() WHERE id = ?', [user.id]);

        res.json({
            message: 'Login berhasil',
            token,
            user: {
                id: user.id,
                id_role: user.id_role,
                nama: user.nama,
                role: user.nama_role
            }
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server' });
    }
};