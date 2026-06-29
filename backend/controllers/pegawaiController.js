const db = require('../config/db');

// Whitelist kolom yang boleh di-sort, supaya parameter sort_by tidak bisa
// dipakai untuk SQL injection (kita hanya izinkan nilai yang sudah kita kenal).
const SORTABLE_COLUMNS = {
    nip: 'p.nip',
    nama_pegawai: 'p.nama_pegawai',
    nama_jabatan: 'nama_jabatan',
    tanggal_masuk: 'p.tanggal_masuk',
    masa_kerja_tahun: 'masa_kerja_tahun'
};

// GET: Mengambil daftar pegawai (dengan search, filter, sort, & pagination)
exports.getAllPegawai = async (req, res) => {
    try {
        const {
            search,            // cari di nama/nip/jabatan
            jabatan,           // bisa multi: ?jabatan=1&jabatan=2 atau "1,2"
            status_kontrak,    // PKWTT | PKWT | Magang
            masa_kerja_min,    // angka tahun
            masa_kerja_max,    // angka tahun
            sort_by = 'tanggal_masuk',
            sort_dir = 'desc',
            page = 1,
            limit = 10
        } = req.query;

        const whereClauses = [];
        const params = [];

        // --- SEARCH: nama / nip / jabatan ---
        if (search && search.trim() !== '') {
            whereClauses.push('(p.nama_pegawai LIKE ? OR p.nip LIKE ? OR m.nama LIKE ?)');
            const likeTerm = `%${search.trim()}%`;
            params.push(likeTerm, likeTerm, likeTerm);
        }

        // --- FILTER: jabatan (multi select, id_jabatan) ---
        if (jabatan) {
            const jabatanArray = Array.isArray(jabatan) ? jabatan : String(jabatan).split(',');
            const validIds = jabatanArray.map(j => parseInt(j, 10)).filter(j => !isNaN(j));
            if (validIds.length > 0) {
                whereClauses.push(`p.id_jabatan IN (${validIds.map(() => '?').join(',')})`);
                params.push(...validIds);
            }
        }

        // --- FILTER: status kontrak ---
        if (status_kontrak && ['PKWTT', 'PKWT', 'Magang'].includes(status_kontrak)) {
            whereClauses.push('p.status_kontrak = ?');
            params.push(status_kontrak);
        }

        // --- FILTER: masa kerja min/max (dalam tahun) ---
        // Catatan: filter ini dipakai di HAVING karena masa_kerja_tahun adalah kolom hasil hitungan (alias)
        const havingClauses = [];
        if (masa_kerja_min !== undefined && masa_kerja_min !== '') {
            havingClauses.push('masa_kerja_tahun >= ?');
            params.push(parseInt(masa_kerja_min, 10));
        }
        if (masa_kerja_max !== undefined && masa_kerja_max !== '') {
            havingClauses.push('masa_kerja_tahun <= ?');
            params.push(parseInt(masa_kerja_max, 10));
        }

        // --- SORT (whitelist supaya aman) ---
        const sortColumn = SORTABLE_COLUMNS[sort_by] || SORTABLE_COLUMNS.tanggal_masuk;
        const sortDirection = String(sort_dir).toLowerCase() === 'asc' ? 'ASC' : 'DESC';

        // --- PAGINATION ---
        const pageNum = Math.max(parseInt(page, 10) || 1, 1);
        const limitNum = Math.max(parseInt(limit, 10) || 10, 1);
        const offset = (pageNum - 1) * limitNum;

        const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
        const havingSql = havingClauses.length > 0 ? `HAVING ${havingClauses.join(' AND ')}` : '';

        // Query utama (dengan LIMIT/OFFSET untuk halaman saat ini)
        const dataQuery = `
            SELECT 
                p.id, p.nip, p.nama_pegawai, p.jenis_kelamin, p.status_kontrak, p.tanggal_masuk,
                m.nama AS nama_jabatan,
                CASE 
                    WHEN p.tanggal_masuk IS NULL THEN NULL
                    ELSE TIMESTAMPDIFF(YEAR, p.tanggal_masuk, CURDATE())
                END AS masa_kerja_tahun
            FROM pegawai p
            LEFT JOIN master_data m ON p.id_jabatan = m.id AND m.tipe = 'jabatan'
            ${whereSql}
            ${havingSql}
            ORDER BY ${sortColumn} ${sortDirection}
            LIMIT ? OFFSET ?
        `;
        const dataParams = [...params, limitNum, offset];
        const [rows] = await db.query(dataQuery, dataParams);

        // Query terpisah untuk hitung total baris (untuk pagination), pakai filter yang sama
        // tapi tanpa LIMIT/OFFSET. Karena ada HAVING pada kolom hasil hitungan, kita bungkus
        // di subquery agar COUNT(*) tetap akurat.
        const countQuery = `
            SELECT COUNT(*) AS total FROM (
                SELECT 
                    p.id,
                    CASE 
                        WHEN p.tanggal_masuk IS NULL THEN NULL
                        ELSE TIMESTAMPDIFF(YEAR, p.tanggal_masuk, CURDATE())
                    END AS masa_kerja_tahun
                FROM pegawai p
                LEFT JOIN master_data m ON p.id_jabatan = m.id AND m.tipe = 'jabatan'
                ${whereSql}
                ${havingSql}
            ) AS filtered
        `;
        const [[{ total }]] = await db.query(countQuery, params);

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
        res.status(500).json({ message: 'Gagal mengambil data pegawai' });
    }
};

// POST: Menambah data pegawai baru
exports.createPegawai = async (req, res) => {
    // Memulai Transaksi Database menggunakan connection pool bawaan kodinganmu
    const conn = await db.getConnection(); 
    
    try {
        // 1. Tangkap seluruh property yang dikirim oleh form Nuxt sesuai struktur tabel
        const { 
            nip, nama_pegawai, email, nomor_hp, jenis_kelamin, 
            tempat_lahir, tanggal_lahir, usia, kecamatan, kabupaten, provinsi, 
            alamat_lengkap, jarak_rumah_kantor, status_kawin, 
            jumlah_anak, tanggal_masuk, id_jabatan, id_departemen, 
            status_kontrak, status, pendidikan 
        } = req.body;
        if (!nip || !/^\d{8,}$/.test(nip)) {
            return res.status(400).json({ message: 'NIP harus berupa angka dan minimal 8 digit.' });
        }
        
        // Validasi aturan format nomor HP internasional
        if (!nomor_hp || !/^\+62\d{8,13}$/.test(nomor_hp)) {
            return res.status(400).json({ message: 'Nomor HP harus menggunakan format internasional, contoh: +62822...' });
        }

        await conn.beginTransaction(); // Mulai mengunci transaksi data

        // 2. Query INSERT yang disesuaikan lengkap dengan seluruh kolom baru
        const sqlPegawai = `
            INSERT INTO pegawai (
                nip, nama_pegawai, email, nomor_hp, jenis_kelamin, 
                tempat_lahir, tanggal_lahir, usia, kecamatan, kabupaten, provinsi, 
                alamat_lengkap, jarak_rumah_kantor, status_kawin, 
                jumlah_anak, tanggal_masuk, id_jabatan, id_departemen, 
                status_kontrak, status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;

        // Gunakan fallback '|| null' atau '|| 0' agar input kosong dari frontend tidak merusak tipe data INT/DATE di MySQL
        const valuesPegawai = [
            nip, 
            nama_pegawai, 
            email, 
            nomor_hp, 
            jenis_kelamin,
            tempat_lahir || null,
            tanggal_lahir || null,
            usia || null,
            kecamatan || null,
            kabupaten || null,
            provinsi || null,
            alamat_lengkap || null,
            jarak_rumah_kantor || 0,
            status_kawin || 'tidak kawin',
            jumlah_anak || 0,
            tanggal_masuk || null,
            id_jabatan || null,
            id_departemen || null,
            status_kontrak,
            status || 'Aktif'
        ];

        const [resultPegawai] = await conn.query(sqlPegawai, valuesPegawai);
        const idPegawaiBaru = resultPegawai.insertId; 

        // 3. Simpan array pendidikan menggunakan pola bulk insert bawaanmu yang sudah aman
        if (pendidikan && Array.isArray(pendidikan) && pendidikan.length > 0) {
            // Saring array untuk memastikan baris yang dikirim tidak kosong datanya
            const validPendidikan = pendidikan.filter(p => p.tingkat && p.sekolah && p.tahun);
            
            if (validPendidikan.length > 0) {
                const pendidikanValues = validPendidikan.map(p => [idPegawaiBaru, p.tingkat, p.sekolah, p.tahun]);
                
                await conn.query(`
                    INSERT INTO pegawai_pendidikan (id_pegawai, tingkat_pendidikan, nama_sekolah, tahun_lulus) 
                    VALUES ?
                `, [pendidikanValues]); 
            }
        }

        await conn.commit(); // Simpan perubahan secara permanen ke MySQL
        res.status(201).json({ message: 'Data pegawai dan riwayat pendidikan berhasil disimpan!' });

    } catch (error) {
        await conn.rollback(); // Batalkan semua eksekusi jika di tengah jalan ada error
        
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ message: 'NIP atau Email sudah terdaftar.' });
        }
        
        console.error(error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server saat menyimpan pegawai.' });
    } finally {
        conn.release(); // Kembalikan koneksi ke Pool agar tidak memory leak
    }
};

// GET: Daftar jabatan dari master_data (untuk dropdown filter di halaman list)
exports.getJabatanList = async (req, res) => {
    try {
        const [rows] = await db.query(
            "SELECT id, nama FROM master_data WHERE tipe = 'jabatan' ORDER BY nama ASC"
        );
        res.json({ data: rows });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil daftar jabatan' });
    }
};

// GET: Mengambil satu data pegawai berdasarkan ID (untuk mode Edit & Detail)
exports.getPegawaiById = async (req, res) => {
    try {
        const { id } = req.params;

        const [rows] = await db.query(`
            SELECT 
                p.*,
                m.nama AS nama_jabatan,
                d.nama_departemen
            FROM pegawai p
            LEFT JOIN master_data m ON p.id_jabatan = m.id AND m.tipe = 'jabatan'
            LEFT JOIN departemen d ON p.id_departemen = d.id
            WHERE p.id = ?
        `, [id]);

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Data pegawai tidak ditemukan' });
        }

        const pegawai = rows[0];

        // Ambil juga riwayat pendidikan supaya form edit bisa langsung terisi
        const [pendidikan] = await db.query(
            'SELECT id, tingkat_pendidikan AS tingkat, nama_sekolah AS sekolah, tahun_lulus AS tahun FROM pegawai_pendidikan WHERE id_pegawai = ?',
            [id]
        );
        pegawai.pendidikan = pendidikan;

        res.json({ data: pegawai });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal mengambil detail data pegawai' });
    }
};

// PUT: Memperbarui data pegawai lama
exports.updatePegawai = async (req, res) => {
    const conn = await db.getConnection();
    try {
        const { id } = req.params; 
        const { 
            nip, nama_pegawai, email, nomor_hp, jenis_kelamin, 
            tempat_lahir, tanggal_lahir, usia, kecamatan, kabupaten, provinsi, 
            alamat_lengkap, jarak_rumah_kantor, status_kawin, 
            jumlah_anak, tanggal_masuk, id_jabatan, id_departemen, 
            status_kontrak, status, pendidikan 
        } = req.body;

        await conn.beginTransaction();

        // 1. Query UPDATE disesuaikan secara menyeluruh untuk semua kolom database
        const sqlUpdate = `
            UPDATE pegawai 
            SET 
                nip = ?, nama_pegawai = ?, email = ?, nomor_hp = ?, jenis_kelamin = ?, 
                tempat_lahir = ?, tanggal_lahir = ?, usia = ?, kecamatan = ?, kabupaten = ?, provinsi = ?, alamat_lengkap = ?, 
                jarak_rumah_kantor = ?, status_kawin = ?, jumlah_anak = ?, tanggal_masuk = ?, 
                id_jabatan = ?, id_departemen = ?, status_kontrak = ?, status = ?
            WHERE id = ?
        `;

        const valuesUpdate = [
            nip, nama_pegawai, email, nomor_hp, jenis_kelamin,
            tempat_lahir || null,
            tanggal_lahir || null,
            usia || null,
            kecamatan || null,
            kabupaten || null,
            provinsi || null,
            alamat_lengkap || null,
            jarak_rumah_kantor || 0,
            status_kawin || 'tidak kawin',
            jumlah_anak || 0,
            tanggal_masuk || null,
            id_jabatan || null,
            id_departemen || null,
            status_kontrak,
            status || 'Aktif',
            id
        ];

        await conn.query(sqlUpdate, valuesUpdate);

        // 2. Sinkronisasi tabel pendidikan menggunakan strategi amandemen bawaanmu (Hapus lama, Masuk baru)
        if (pendidikan && Array.isArray(pendidikan)) {
            await conn.query('DELETE FROM pegawai_pendidikan WHERE id_pegawai = ?', [id]);
            
            const validPendidikan = pendidikan.filter(p => p.tingkat && p.sekolah && p.tahun);
            if (validPendidikan.length > 0) {
                const pendidikanValues = validPendidikan.map(p => [id, p.tingkat, p.sekolah, p.tahun]);
                await conn.query(`
                    INSERT INTO pegawai_pendidikan (id_pegawai, tingkat_pendidikan, nama_sekolah, tahun_lulus) 
                    VALUES ?
                `, [pendidikanValues]);
            }
        }

        await conn.commit();
        res.json({ message: 'Data pegawai berhasil diperbarui!' });

    } catch (error) {
        await conn.rollback();
        console.error(error);
        res.status(500).json({ message: 'Terjadi kesalahan saat memperbarui pegawai' });
    } finally {
        conn.release();
    }
};

// DELETE: Menghapus data pegawai
exports.deletePegawai = async (req, res) => {
    try {
        const { id } = req.params;
        
        // Karena di database kita sudah set "ON DELETE CASCADE", 
        // menghapus pegawai otomatis akan menghapus riwayat pendidikannya juga
        await db.query('DELETE FROM pegawai WHERE id = ?', [id]);
        
        res.json({ message: 'Data pegawai berhasil dihapus!' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Gagal menghapus data pegawai' });
    }
};