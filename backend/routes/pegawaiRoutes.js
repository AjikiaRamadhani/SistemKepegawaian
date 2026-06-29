const express = require('express');
const router = express.Router();
const pegawaiController = require('../controllers/pegawaiController');
const { verifyToken } = require('../middleware/authMiddleware');
const { checkPermission } = require('../middleware/rbacMiddleware');
const { logActivity } = require('../middleware/logMiddleware'); // Import Log

// Manager HRD: read saja. Admin HRD: create/read/update/delete.
router.get('/', verifyToken, checkPermission('data_pegawai', 'read'), logActivity('Melihat semua pegawai'), pegawaiController.getAllPegawai);
// PENTING: route ini harus didaftarkan SEBELUM '/:id', supaya 'master' tidak
// tertangkap oleh parameter :id
router.get('/master/jabatan', verifyToken, checkPermission('data_pegawai', 'read'), pegawaiController.getJabatanList);
router.get('/:id', verifyToken, checkPermission('data_pegawai', 'read'), logActivity('Melihat detail pegawai'), pegawaiController.getPegawaiById);
router.post('/', verifyToken, checkPermission('data_pegawai', 'create'), logActivity('Membuat pegawai baru'), pegawaiController.createPegawai);
router.put('/:id', verifyToken, checkPermission('data_pegawai', 'update'), logActivity('Memperbarui pegawai'), pegawaiController.updatePegawai);
router.delete('/:id', verifyToken, checkPermission('data_pegawai', 'delete'), logActivity('Menghapus pegawai'), pegawaiController.deletePegawai);

module.exports = router;