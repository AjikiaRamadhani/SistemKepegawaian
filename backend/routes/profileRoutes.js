const express = require('express');
const router = express.Router();
const profileController = require('../controllers/profileController');
const { verifyToken } = require('../middleware/authMiddleware');
const { checkPermission } = require('../middleware/rbacMiddleware');
const { logActivity } = require('../middleware/logMiddleware');

/**
 * @swagger
 * components:
 *   schemas:
 *     MyProfile:
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
 *         last_login:
 *           type: string
 *           format: date-time
 *         nama_role:
 *           type: string
 *           example: "Admin HRD"
 *         nip:
 *           type: string
 *           example: "20240001"
 *         nama_jabatan:
 *           type: string
 *           example: "Staf HRD"
 *         nama_departemen:
 *           type: string
 *           example: "HRD"
 */

/**
 * @swagger
 * /api/profile:
 *   get:
 *     summary: Mengambil data profil milik akun yang sedang login (Read Own)
 *     tags: [My Profile]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Data profil
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   $ref: '#/components/schemas/MyProfile'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       404:
 *         description: Profil tidak ditemukan
 *   put:
 *     summary: Memperbarui profil milik sendiri -- email dan/atau password (Update Own)
 *     description: >
 *       Mengganti password membutuhkan current_password yang benar.
 *       Aturan password baru sama seperti aturan pembuatan user baru:
 *       minimal 8 karakter, tanpa spasi, ada huruf besar, huruf kecil, dan karakter khusus.
 *     tags: [My Profile]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 example: "budi.baru@jmc.com"
 *               current_password:
 *                 type: string
 *                 example: "PasswordLama123!"
 *               new_password:
 *                 type: string
 *                 example: "PasswordBaru456!"
 *     responses:
 *       200:
 *         description: Profil berhasil diperbarui
 *       400:
 *         description: Password saat ini salah, password baru tidak valid, atau email tidak valid/sudah dipakai
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       404:
 *         description: User tidak ditemukan
 */
router.get('/', verifyToken, checkPermission('my_profile', 'read'), profileController.getMyProfile);
router.put('/', verifyToken, checkPermission('my_profile', 'update'), logActivity('My Profile'), profileController.updateMyProfile);

module.exports = router;