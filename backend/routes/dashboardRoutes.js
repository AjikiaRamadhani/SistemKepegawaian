const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController');
const { verifyToken } = require('../middleware/authMiddleware'); // Import middleware
const { checkPermission } = require('../middleware/rbacMiddleware');

// Endpoint: GET /api/dashboard
// Middleware dipasang di tengah sebelum controller dieksekusi
router.get('/', verifyToken, checkPermission('dashboard', 'read'), dashboardController.getDashboard);

module.exports = router;