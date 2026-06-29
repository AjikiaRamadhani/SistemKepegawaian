const db = require('../config/db');

// GET: Daftar log aktivitas (siapa, kapan, modul apa, aksi apa)
// Sesuai soal: Superadmin bisa Read seluruh log.
exports.getAllLogs = async (req, res) => {
    try {
        const {
            search,       // cari di title/content/nama user
            tanggal_dari,
            tanggal_sampai,
            page = 1,
            limit = 10
        } = req.query;

        const whereClauses = [];
        const params = [];

        if (search && search.trim() !== '') {
            whereClauses.push('(a.title LIKE ? OR a.content LIKE ? OR u.nama LIKE ?)');
            const likeTerm = `%${search.trim()}%`;
            params.push(likeTerm, likeTerm, likeTerm);
        }

        if (tanggal_dari) {
            whereClauses.push('a.created_at >= ?');
            params.push(`${tanggal_dari} 00:00:00`);
        }

        if (tanggal_sampai) {
            whereClauses.push('a.created_at <= ?');
            params.push(`${tanggal_sampai} 23:59:59`);
        }

        const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

        const pageNum = Math.max(parseInt(page, 10) || 1, 1);
        const limitNum = Math.max(parseInt(limit, 10) || 10, 1);
        const offset = (pageNum - 1) * limitNum;

        const [rows] = await db.query(`
            SELECT 
                a.id, a.title, a.content, a.ip, a.url, a.created_at,
                u.nama AS nama_user, u.username
            FROM activities a
            LEFT JOIN user u ON a.created_by = u.id
            ${whereSql}
            ORDER BY a.created_at DESC
            LIMIT ? OFFSET ?
        `, [...params, limitNum, offset]);

        const [[{ total }]] = await db.query(`
            SELECT COUNT(*) AS total
            FROM activities a
            LEFT JOIN user u ON a.created_by = u.id
            ${whereSql}
        `, params);

        res.json({
            data: rows,
            pagination: {
                page: pageNum,
                limit: limitNum,
                total,
                total_pages: Math.ceil(total / limitNum)
            }
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil data log aktivitas' });
    }
};