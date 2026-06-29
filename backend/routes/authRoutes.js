const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { logActivity } = require('../middleware/logMiddleware'); // Import Log

// Endpoint: POST /api/auth/login
router.post('/login', logActivity('Login/ Logout'), authController.login);

module.exports = router;