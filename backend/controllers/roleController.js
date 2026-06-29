const db = require('../config/db');

// GET: Daftar seluruh role (untuk halaman List Role)
// Sesuai soal: Role, Deskripsi (ringkasan hak akses), dan tombol Hak Akses.
// Tabel user_role tidak punya kolom deskripsi, jadi kita generate ringkasan
// deskripsi otomatis berdasarkan jumlah modul yang bisa diakses role tersebut.
exports.getAllRoles = async (req, res) => {
    try {
        const [roles] = await db.query('SELECT id, nama_role FROM user_role ORDER BY id ASC');

        // Untuk setiap role, hitung berapa modul yang punya akses (akses = 1)
        // supaya bisa ditampilkan sebagai ringkasan deskripsi di table view.
        const rolesWithDescription = await Promise.all(
            roles.map(async (role) => {
                const [modules] = await db.query(
                    'SELECT modul_fitur FROM role_permission WHERE id_role = ? AND akses = 1',
                    [role.id]
                );
                const daftarModul = modules.map(m => m.modul_fitur).join(', ');
                return {
                    ...role,
                    deskripsi: daftarModul
                        ? `Memiliki akses ke modul: ${daftarModul}`
                        : 'Belum memiliki akses ke modul apapun'
                };
            })
        );

        res.json({ data: rolesWithDescription });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil daftar role' });
    }
};

// GET: Detail hak akses satu role (untuk halaman Detail Hak Akses, view only)
// Sesuai soal, kolom table view: Modul/Fitur, Akses, Create, Read, Update, Delete
exports.getRoleDetail = async (req, res) => {
    try {
        const { id } = req.params;

        const [roleRows] = await db.query('SELECT id, nama_role FROM user_role WHERE id = ?', [id]);
        if (roleRows.length === 0) {
            return res.status(404).json({ message: 'Role tidak ditemukan' });
        }

        const [permissions] = await db.query(
            'SELECT modul_fitur, akses, `create`, `read`, `update`, `delete` FROM role_permission WHERE id_role = ? ORDER BY modul_fitur ASC',
            [id]
        );

        res.json({
            data: {
                role: roleRows[0],
                permissions
            }
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil detail hak akses role' });
    }
};