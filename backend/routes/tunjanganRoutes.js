const express = require('express');
const router = express.Router();
const tunjanganController = require('../controllers/tunjanganController');
const { verifyToken } = require('../middleware/authMiddleware');
const { checkPermission } = require('../middleware/rbacMiddleware');

/**
 * @swagger
 * components:
 *   schemas:
 *     SettingTunjangan:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 1
 *         base_fare:
 *           type: integer
 *           description: Tarif tunjangan per kilometer (Rupiah)
 *           example: 5000
 *         berlaku_mulai:
 *           type: string
 *           format: date
 *           example: "2026-06-01"
 *         min_km:
 *           type: integer
 *           description: Jarak minimal (km) agar pegawai berhak menerima tunjangan
 *           example: 5
 *         max_km:
 *           type: integer
 *           description: Jarak maksimal (km) yang dihitung tunjangan
 *           example: 25
 *     RiwayatTunjanganBulanan:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 4
 *         bulan:
 *           type: integer
 *           example: 6
 *         tahun:
 *           type: integer
 *           example: 2026
 *         total_penerima:
 *           type: integer
 *           example: 1
 *         total_nominal:
 *           type: integer
 *           example: 1430000
 *     DetailTunjangan:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 2
 *         id_tunjangan_bulanan:
 *           type: integer
 *           example: 4
 *         id_pegawai:
 *           type: integer
 *           example: 9
 *         nama_pegawai:
 *           type: string
 *           example: "Iqbal"
 *         jarak_km:
 *           type: integer
 *           example: 11
 *         jumlah_hari:
 *           type: integer
 *           example: 26
 *         nominal:
 *           type: integer
 *           example: 1430000
 */

/**
 * @swagger
 * /api/tunjangan/hitung:
 *   post:
 *     summary: Menghitung tunjangan transport pegawai untuk bulan berjalan
 *     description: >
 *       Menghitung tunjangan transport setiap pegawai berdasarkan data kehadiran yang dikirim.
 *       Hanya pegawai dengan status kontrak PKWTT dan jumlah hari kerja minimal 19 hari yang
 *       berhak menerima tunjangan. Jarak yang dihitung dibatasi antara min_km dan max_km
 *       sesuai pengaturan di endpoint /setting.
 *     tags: [Tunjangan]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - bulan
 *               - tahun
 *               - kehadiran
 *             properties:
 *               bulan:
 *                 type: integer
 *                 example: 6
 *                 description: Bulan berjalan (1-12)
 *               tahun:
 *                 type: integer
 *                 example: 2026
 *               kehadiran:
 *                 type: array
 *                 description: Daftar kehadiran pegawai pada bulan berjalan
 *                 items:
 *                   type: object
 *                   properties:
 *                     id_pegawai:
 *                       type: integer
 *                       example: 9
 *                     jumlah_hari:
 *                       type: integer
 *                       example: 26
 *     responses:
 *       201:
 *         description: Perhitungan berhasil disimpan
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Berhasil
 *                 data:
 *                   type: object
 *                   properties:
 *                     total_penerima:
 *                       type: integer
 *                       example: 1
 *                     total_nominal:
 *                       type: integer
 *                       example: 1430000
 *       400:
 *         description: Data input tidak lengkap, atau setting tunjangan belum diatur
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       500:
 *         description: Kesalahan pada server
 */
router.post('/hitung', verifyToken, checkPermission('tunjangan_transport', 'read'), tunjanganController.hitungTunjangan);

/**
 * @swagger
 * /api/tunjangan/setting:
 *   get:
 *     summary: Mengambil pengaturan tunjangan transport yang sedang berlaku
 *     tags: [Tunjangan]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Data setting tunjangan
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   $ref: '#/components/schemas/SettingTunjangan'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       500:
 *         description: Kesalahan pada server
 *   put:
 *     summary: Memperbarui pengaturan tunjangan transport (khusus Admin HRD)
 *     tags: [Tunjangan]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - base_fare
 *               - berlaku_mulai
 *               - min_km
 *               - max_km
 *             properties:
 *               base_fare:
 *                 type: integer
 *                 example: 5000
 *               berlaku_mulai:
 *                 type: string
 *                 format: date
 *                 example: "2026-07-01"
 *               min_km:
 *                 type: integer
 *                 example: 5
 *               max_km:
 *                 type: integer
 *                 example: 25
 *     responses:
 *       200:
 *         description: Update berhasil
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini (hanya Admin HRD)
 *       500:
 *         description: Kesalahan pada server
 */
router.get('/setting', verifyToken, checkPermission('setting_tunjangan', 'read'), tunjanganController.getSetting);
router.put('/setting', verifyToken, checkPermission('setting_tunjangan', 'update'), tunjanganController.updateSetting);

/**
 * @swagger
 * /api/tunjangan/riwayat:
 *   get:
 *     summary: Mengambil daftar riwayat tunjangan transport per bulan
 *     description: Menampilkan rekap tunjangan transport yang sudah dihitung untuk setiap bulan berjalan.
 *     tags: [Tunjangan]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Daftar riwayat tunjangan bulanan
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/RiwayatTunjanganBulanan'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       500:
 *         description: Kesalahan pada server
 */
router.get('/riwayat', verifyToken, checkPermission('tunjangan_transport', 'read'), tunjanganController.getRiwayatTunjangan);

/**
 * @swagger
 * /api/tunjangan/riwayat/{id_bulanan}:
 *   get:
 *     summary: Mengambil detail penerima tunjangan transport pada bulan tertentu
 *     tags: [Tunjangan]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id_bulanan
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID baris pada tabel tunjangan_bulanan
 *         example: 4
 *     responses:
 *       200:
 *         description: Daftar detail penerima tunjangan pada bulan tersebut
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/DetailTunjangan'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       500:
 *         description: Kesalahan pada server
 */
router.get('/riwayat/:id_bulanan', verifyToken, checkPermission('tunjangan_transport', 'read'), tunjanganController.getDetailTunjangan);

/**
 * @swagger
 * /api/tunjangan/cek/{bulan}/{tahun}:
 *   get:
 *     summary: Memeriksa apakah tunjangan transport bulan tertentu sudah pernah dihitung
 *     description: >
 *       Jika bulan/tahun yang diminta sudah pernah dihitung, mengembalikan data hasil
 *       perhitungan (bulanan + detail). Jika belum, mengembalikan daftar pegawai PKWTT
 *       aktif yang siap diisi jumlah hari kerjanya sebelum tombol "Hitung Tunjangan" ditekan.
 *     tags: [Tunjangan]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: bulan
 *         required: true
 *         schema:
 *           type: integer
 *         example: 6
 *       - in: path
 *         name: tahun
 *         required: true
 *         schema:
 *           type: integer
 *         example: 2026
 *     responses:
 *       200:
 *         description: Status bulan berhasil diperiksa
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 sudah_dihitung:
 *                   type: boolean
 *                 bulanan:
 *                   $ref: '#/components/schemas/RiwayatTunjanganBulanan'
 *                 detail:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/DetailTunjangan'
 *                 pegawai:
 *                   type: array
 *                   description: Hanya ada jika sudah_dihitung = false
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       nip:
 *                         type: string
 *                       nama_pegawai:
 *                         type: string
 *                       jarak_rumah_kantor:
 *                         type: integer
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       500:
 *         description: Kesalahan pada server
 */
router.get('/cek/:bulan/:tahun', verifyToken, checkPermission('tunjangan_transport', 'read'), tunjanganController.cekStatusBulan);

module.exports = router;