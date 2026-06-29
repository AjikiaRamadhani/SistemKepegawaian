const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { verifyToken } = require('../middleware/authMiddleware');
const { checkPermission } = require('../middleware/rbacMiddleware');
const { logActivity } = require('../middleware/logMiddleware'); // Import Log

/**
 * @swagger
 * components:
 *   schemas:
 *     UserAccount:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 2
 *         username:
 *           type: string
 *           example: "budisantoso"
 *         nama:
 *           type: string
 *           example: "Budi Santoso"
 *         email:
 *           type: string
 *           example: "budi@jmc.com"
 *         disabled:
 *           type: integer
 *           description: 0 = aktif, 1 = nonaktif
 *           example: 0
 *         id_role:
 *           type: integer
 *           example: 3
 *         nama_role:
 *           type: string
 *           example: "Admin HRD"
 *         nama_jabatan:
 *           type: string
 *           example: "Staf HRD"
 *         nama_departemen:
 *           type: string
 *           example: "HRD"
 */

/**
 * @swagger
 * /api/user:
 *   get:
 *     summary: Mengambil daftar seluruh user (khusus Superadmin)
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Cari berdasarkan nama atau username
 *       - in: query
 *         name: id_role
 *         schema:
 *           type: integer
 *         description: Filter berdasarkan role
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [aktif, nonaktif]
 *     responses:
 *       200:
 *         description: Daftar user
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/UserAccount'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *   post:
 *     summary: Membuat user baru (khusus Superadmin)
 *     description: >
 *       Password digenerate otomatis oleh sistem dan hanya ditampilkan sekali pada response.
 *       Pegawai yang sudah memiliki akun user tidak akan muncul lagi di autosuggest.
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - id_pegawai
 *               - username
 *               - id_role
 *             properties:
 *               id_pegawai:
 *                 type: integer
 *                 example: 5
 *               username:
 *                 type: string
 *                 example: "budisantoso"
 *               id_role:
 *                 type: integer
 *                 example: 3
 *     responses:
 *       201:
 *         description: User berhasil dibuat, termasuk password yang digenerate
 *       400:
 *         description: Data tidak lengkap, username tidak valid, atau username sudah dipakai
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       404:
 *         description: Pegawai tidak ditemukan
 */
router.get('/', verifyToken, checkPermission('kelola_user', 'read'), userController.getAllUsers);
router.post('/', verifyToken, checkPermission('kelola_user', 'create'), logActivity('Kelola User'), userController.createUser);

/**
 * @swagger
 * /api/user/roles:
 *   get:
 *     summary: Mengambil daftar role yang tersedia (untuk dropdown form)
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Daftar role
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 */
router.get('/roles', verifyToken, checkPermission('kelola_user', 'read'), userController.getRoleList);

/**
 * @swagger
 * /api/user/pegawai-suggest:
 *   get:
 *     summary: Autosuggest nama pegawai untuk form Tambah User
 *     description: >
 *       Hanya menampilkan pegawai yang belum memiliki akun user. Membutuhkan
 *       minimal 2 karakter sebelum hasil ditampilkan, sesuai aturan di soal.
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: q
 *         required: true
 *         schema:
 *           type: string
 *         description: Minimal 2 karakter nama pegawai yang dicari
 *         example: "su"
 *     responses:
 *       200:
 *         description: Daftar pegawai yang cocok
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 */
router.get('/pegawai-suggest', verifyToken, checkPermission('kelola_user', 'create'), userController.getPegawaiAutosuggest);

/**
 * @swagger
 * /api/user/{id}:
 *   put:
 *     summary: Memperbarui role dan/atau status user (khusus Superadmin)
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id_role:
 *                 type: integer
 *                 example: 2
 *               disabled:
 *                 type: integer
 *                 example: 0
 *     responses:
 *       200:
 *         description: User berhasil diperbarui
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       404:
 *         description: User tidak ditemukan
 *   delete:
 *     summary: Menghapus user (khusus Superadmin, tidak bisa menghapus akun sendiri)
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: User berhasil dihapus
 *       400:
 *         description: Tidak dapat menghapus akun sendiri
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       404:
 *         description: User tidak ditemukan
 */
router.put('/:id', verifyToken, checkPermission('kelola_user', 'update'), logActivity('Mengubah user'), userController.updateUser);
router.delete('/:id', verifyToken, checkPermission('kelola_user', 'delete'), logActivity('Menghapus user'), userController.deleteUser);

/**
 * @swagger
 * /api/user/{id}/toggle-status:
 *   patch:
 *     summary: Mengaktifkan/menonaktifkan user secara cepat (tidak bisa pada akun sendiri)
 *     tags: [Kelola User]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Status berhasil diubah
 *       400:
 *         description: Tidak dapat mengubah status akun sendiri
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       404:
 *         description: User tidak ditemukan
 */
router.patch('/:id/toggle-status', verifyToken, checkPermission('kelola_user', 'update'), logActivity('Mengubah status user'), userController.toggleStatusUser);

module.exports = router;