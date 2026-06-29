const express = require('express');
const router = express.Router();
const logController = require('../controllers/logController');
const { verifyToken } = require('../middleware/authMiddleware');
const { checkPermission } = require('../middleware/rbacMiddleware');

/**
 * @swagger
 * components:
 *   schemas:
 *     ActivityLog:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 14
 *         title:
 *           type: string
 *           example: "Akses Modul: Kelola User"
 *         content:
 *           type: string
 *           example: "User melakukan aksi Membuat pada modul Kelola User."
 *         ip:
 *           type: string
 *           example: "::1"
 *         url:
 *           type: string
 *           example: "/api/user"
 *         created_at:
 *           type: string
 *           format: date-time
 *         nama_user:
 *           type: string
 *           example: "Super Admin"
 *         username:
 *           type: string
 *           example: "superadmin"
 */

/**
 * @swagger
 * /api/log:
 *   get:
 *     summary: Mengambil daftar log aktivitas (khusus Superadmin, read only)
 *     description: >
 *       Mencatat siapa login/logout kapan, modul apa yang diakses, dan aksi
 *       apa yang dilakukan (create/read/update/delete), sesuai soal Modul Log.
 *     tags: [Modul Log]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Cari berdasarkan judul, isi log, atau nama user
 *       - in: query
 *         name: tanggal_dari
 *         schema:
 *           type: string
 *           format: date
 *       - in: query
 *         name: tanggal_sampai
 *         schema:
 *           type: string
 *           format: date
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *     responses:
 *       200:
 *         description: Daftar log aktivitas
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/ActivityLog'
 *                 pagination:
 *                   type: object
 *                   properties:
 *                     page:
 *                       type: integer
 *                     limit:
 *                       type: integer
 *                     total:
 *                       type: integer
 *                     total_pages:
 *                       type: integer
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 */
router.get('/', verifyToken, checkPermission('log', 'read'), logController.getAllLogs);

module.exports = router;