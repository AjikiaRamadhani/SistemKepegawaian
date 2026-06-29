const express = require('express');
const router = express.Router();
const roleController = require('../controllers/roleController');
const { verifyToken } = require('../middleware/authMiddleware');
const { checkPermission } = require('../middleware/rbacMiddleware');

/**
 * @swagger
 * components:
 *   schemas:
 *     RoleSummary:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 2
 *         nama_role:
 *           type: string
 *           example: "Manager HRD"
 *         deskripsi:
 *           type: string
 *           example: "Memiliki akses ke modul: login, my_profile, dashboard, data_pegawai, tunjangan_transport"
 *     RolePermissionDetail:
 *       type: object
 *       properties:
 *         modul_fitur:
 *           type: string
 *           example: "data_pegawai"
 *         akses:
 *           type: integer
 *           example: 1
 *         create:
 *           type: integer
 *           example: 0
 *         read:
 *           type: string
 *           enum: [All, Own, No]
 *           example: "All"
 *         update:
 *           type: string
 *           enum: [All, Own, No]
 *           example: "No"
 *         delete:
 *           type: string
 *           enum: [All, Own, No]
 *           example: "No"
 */

/**
 * @swagger
 * /api/role:
 *   get:
 *     summary: Mengambil daftar seluruh role (khusus Superadmin, view only)
 *     description: >
 *       Sesuai soal, perubahan hak akses tidak dilakukan lewat UI, melainkan
 *       langsung di database pada tabel role_permission.
 *     tags: [Kelola Role]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Daftar role
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/RoleSummary'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 */
router.get('/', verifyToken, checkPermission('kelola_role', 'read'), roleController.getAllRoles);

/**
 * @swagger
 * /api/role/{id}:
 *   get:
 *     summary: Mengambil detail hak akses satu role (view only)
 *     tags: [Kelola Role]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 2
 *     responses:
 *       200:
 *         description: Detail hak akses role
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: object
 *                   properties:
 *                     role:
 *                       type: object
 *                       properties:
 *                         id:
 *                           type: integer
 *                         nama_role:
 *                           type: string
 *                     permissions:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/RolePermissionDetail'
 *       401:
 *         description: Token tidak ada atau tidak valid
 *       403:
 *         description: Role tidak memiliki hak akses ke modul ini
 *       404:
 *         description: Role tidak ditemukan
 */
router.get('/:id', verifyToken, checkPermission('kelola_role', 'read'), roleController.getRoleDetail);

module.exports = router;