const db = require('../config/db');
const bcrypt = require('bcrypt');

// Fungsi bantuan untuk generate password acak yang aman
const generateSecurePassword = () => {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const specials = '!@#$%^&*()_+~`|}{[]:;?><,./-=';
    
    // Pastikan ada minimal 1 dari setiap jenis karakter
    let password = '';
    password += uppercase[Math.floor(Math.random() * uppercase.length)];
    password += lowercase[Math.floor(Math.random() * lowercase.length)];
    password += numbers[Math.floor(Math.random() * numbers.length)];
    password += specials[Math.floor(Math.random() * specials.length)];
    
    // Isi sisanya (4 karakter) secara acak
    const allChars = uppercase + lowercase + numbers + specials;
    for (let i = 0; i < 4; i++) {
        password += allChars[Math.floor(Math.random() * allChars.length)];
    }
    
    // Acak urutan stringnya agar polanya tidak ketebak
    return password.split('').sort(() => 0.5 - Math.random()).join('');
};

exports.createUser = async (req, res) => {
    try {
        const { id_pegawai, username, id_role } = req.body;

        if (!id_pegawai || !username || !id_role) {
            return res.status(400).json({ message: 'Data tidak lengkap' });
        }

        // Cek format username (huruf kecil & angka, tanpa spasi, min 6 char)
        if (!/^[a-z0-9]{6,}$/.test(username)) {
            return res.status(400).json({ message: 'Username tidak valid. Minimal 6 karakter, tanpa spasi, huruf kecil & angka saja.' });
        }

        // Ambil email dari tabel pegawai untuk digabungkan
        const [pegawai] = await db.query('SELECT email, nama_pegawai FROM pegawai WHERE id = ?', [id_pegawai]);
        if (pegawai.length === 0) return res.status(404).json({ message: 'Pegawai tidak ditemukan' });

        const email = pegawai[0].email;
        const nama = pegawai[0].nama_pegawai;

        // Generate password dan lakukan hashing
        const rawPassword = generateSecurePassword();
        const hashedPassword = await bcrypt.hash(rawPassword, 10);

        // Simpan ke tabel user
        await db.query(
            `INSERT INTO user (id_role, id_pegawai, username, password_hash, nama, email, disabled) 
             VALUES (?, ?, ?, ?, ?, ?, 0)`,
            [id_role, id_pegawai, username, hashedPassword, nama, email]
        );

        res.status(201).json({
            message: 'User berhasil dibuat',
            data: {
                username: username,
                generated_password: rawPassword // Dikembalikan sekali saja untuk disalin admin
            }
        });

    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ message: 'Username sudah digunakan' });
        }
        console.error(error);
        res.status(500).json({ message: 'Terjadi kesalahan saat membuat user' });
    }
};

// GET: Daftar seluruh user (untuk table view Kelola User)
exports.getAllUsers = async (req, res) => {
    try {
        const { search, id_role, status } = req.query;

        const whereClauses = [];
        const params = [];

        if (search && search.trim() !== '') {
            whereClauses.push('(u.nama LIKE ? OR u.username LIKE ?)');
            const likeTerm = `%${search.trim()}%`;
            params.push(likeTerm, likeTerm);
        }

        if (id_role) {
            whereClauses.push('u.id_role = ?');
            params.push(parseInt(id_role, 10));
        }

        if (status === 'aktif') {
            whereClauses.push('u.disabled = 0');
        } else if (status === 'nonaktif') {
            whereClauses.push('u.disabled = 1');
        }

        const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

        const [rows] = await db.query(`
            SELECT 
                u.id, u.username, u.nama, u.email, u.disabled, u.id_role, u.id_pegawai,
                r.nama_role,
                m.nama AS nama_jabatan,
                d.nama_departemen
            FROM user u
            LEFT JOIN user_role r ON u.id_role = r.id
            LEFT JOIN pegawai p ON u.id_pegawai = p.id
            LEFT JOIN master_data m ON p.id_jabatan = m.id AND m.tipe = 'jabatan'
            LEFT JOIN departemen d ON p.id_departemen = d.id
            ${whereSql}
            ORDER BY u.created_at DESC
        `, params);

        res.json({ data: rows });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil daftar user' });
    }
};

// GET: Daftar role (untuk dropdown filter & form)
exports.getRoleList = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, nama_role FROM user_role ORDER BY id ASC');
        res.json({ data: rows });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil daftar role' });
    }
};

// GET: Autosuggest nama pegawai untuk form Tambah User
// Sesuai soal: pegawai harus diketik minimal 2 karakter, dan hanya bisa
// memilih dari hasil yang muncul (tidak boleh ketik nama bebas).
// Hanya pegawai yang BELUM punya akun user yang ditampilkan, supaya tidak
// membuat user duplikat untuk satu pegawai yang sama.
exports.getPegawaiAutosuggest = async (req, res) => {
    try {
        const { q } = req.query;
        if (!q || q.trim().length < 2) {
            return res.json({ data: [] });
        }

        const [rows] = await db.query(`
            SELECT p.id, p.nip, p.nama_pegawai, p.email
            FROM pegawai p
            WHERE p.nama_pegawai LIKE ?
              AND p.id NOT IN (SELECT id_pegawai FROM user WHERE id_pegawai IS NOT NULL)
            ORDER BY p.nama_pegawai ASC
            LIMIT 10
        `, [`%${q.trim()}%`]);

        res.json({ data: rows });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil saran pegawai' });
    }
};

// PUT: Memperbarui user (role dan/atau status aktif)
// Sesuai matriks soal: Superadmin CRUD user kecuali menghapus dirinya sendiri.
// Username & password tidak diubah lewat endpoint ini -- password diperbarui
// mandiri oleh user lewat halaman profil masing-masing (sesuai soal modul My Profile).
exports.updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { id_role, disabled } = req.body;

        const [existing] = await db.query('SELECT id FROM user WHERE id = ?', [id]);
        if (existing.length === 0) {
            return res.status(404).json({ message: 'User tidak ditemukan' });
        }

        await db.query(
            'UPDATE user SET id_role = ?, disabled = ? WHERE id = ?',
            [id_role, disabled ? 1 : 0, id]
        );

        res.json({ message: 'User berhasil diperbarui' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal memperbarui user' });
    }
};

// PATCH: Toggle status aktif/nonaktif user secara cepat (dari tombol di table view)
exports.toggleStatusUser = async (req, res) => {
    try {
        const { id } = req.params;

        // Superadmin tidak boleh menonaktifkan dirinya sendiri
        if (req.user && String(req.user.id) === String(id)) {
            return res.status(400).json({ message: 'Tidak dapat mengubah status akun Anda sendiri.' });
        }

        const [rows] = await db.query('SELECT disabled FROM user WHERE id = ?', [id]);
        if (rows.length === 0) {
            return res.status(404).json({ message: 'User tidak ditemukan' });
        }

        const statusBaru = rows[0].disabled ? 0 : 1;
        await db.query('UPDATE user SET disabled = ? WHERE id = ?', [statusBaru, id]);

        res.json({ message: 'Status user berhasil diperbarui', disabled: statusBaru });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengubah status user' });
    }
};

// DELETE: Menghapus user
// Sesuai soal: Superadmin tidak boleh menghapus akunnya sendiri.
exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params;

        if (req.user && String(req.user.id) === String(id)) {
            return res.status(400).json({ message: 'Anda tidak dapat menghapus akun Anda sendiri.' });
        }

        const [existing] = await db.query('SELECT id FROM user WHERE id = ?', [id]);
        if (existing.length === 0) {
            return res.status(404).json({ message: 'User tidak ditemukan' });
        }

        await db.query('DELETE FROM user WHERE id = ?', [id]);
        res.json({ message: 'User berhasil dihapus' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal menghapus user' });
    }
};