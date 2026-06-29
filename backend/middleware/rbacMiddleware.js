const db = require('../config/db');

/**
 * Middleware RBAC (Role Based Access Control).
 *
 * Dipasang SETELAH verifyToken (butuh req.user.id_role dari JWT).
 * Mengecek ke tabel `role_permission` apakah role user diizinkan
 * melakukan aksi tertentu (create/read/update/delete) pada modul tertentu.
 *
 * Hak akses TIDAK di-hardcode di kode -- semua bersumber dari tabel
 * role_permission, sesuai instruksi soal: "perubahan hak akses harus
 * dilakukan melalui database".
 *
 * Penggunaan:
 *   router.post('/', verifyToken, checkPermission('data_pegawai', 'create'), controller.create);
 *   router.get('/', verifyToken, checkPermission('data_pegawai', 'read'), controller.getAll);
 *
 * @param {string} modulFitur - key modul, harus sama dengan kolom modul_fitur di tabel role_permission
 * @param {'create'|'read'|'update'|'delete'} aksi - jenis aksi yang ingin dilakukan
 */
exports.checkPermission = (modulFitur, aksi) => {
    return async (req, res, next) => {
        try {
            if (!req.user || !req.user.id_role) {
                return res.status(401).json({ message: 'Akses ditolak. Role tidak teridentifikasi pada token.' });
            }

            const [rows] = await db.query(
                'SELECT * FROM role_permission WHERE id_role = ? AND modul_fitur = ? LIMIT 1',
                [req.user.id_role, modulFitur]
            );

            // Tidak ada baris permission sama sekali untuk role+modul ini -> tolak
            if (rows.length === 0) {
                return res.status(403).json({ message: 'Akses ditolak. Anda tidak memiliki hak akses ke modul ini.' });
            }

            const permission = rows[0];

            // akses=0 berarti role ini sama sekali tidak boleh masuk ke modul ini
            if (!permission.akses) {
                return res.status(403).json({ message: 'Akses ditolak. Anda tidak memiliki hak akses ke modul ini.' });
            }

            // Untuk aksi 'create', kolomnya tinyint (0/1)
            if (aksi === 'create') {
                if (!permission.create) {
                    return res.status(403).json({ message: 'Akses ditolak. Anda tidak memiliki hak untuk membuat data pada modul ini.' });
                }
                req.permissionScope = 'All'; // create tidak punya scope Own/All
                return next();
            }

            // Untuk read/update/delete, kolomnya enum('All','Own','No')
            const scope = permission[aksi]; // 'All' | 'Own' | 'No'
            if (!scope || scope === 'No') {
                return res.status(403).json({ message: `Akses ditolak. Anda tidak memiliki hak untuk aksi ini pada modul ini.` });
            }

            // Simpan scope ('All' atau 'Own') agar controller bisa membatasi
            // query-nya sendiri (misal: Own -> hanya boleh row miliknya sendiri)
            req.permissionScope = scope;
            next();

        } catch (error) {
            console.error('Gagal memeriksa hak akses:', error);
            res.status(500).json({ message: 'Terjadi kesalahan saat memeriksa hak akses.' });
        }
    };
};