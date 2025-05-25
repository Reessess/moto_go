const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { resetPasswordHandler } = require('../controllers/authController');

// Admin login route
router.post('/admin-login', authController.adminLogin);

// User registration route
router.post('/register', authController.register);

// User login route
router.post('/login', authController.userLogin);

router.get('/login', authController.userLogin);

router.get('/profile', authController.getUserProfile);

// Add this line for profile update route
router.put('/profile/update', authController.updateProfile);

// Example in authRoutes.js or similar
router.post('/forgot-password', resetPasswordHandler);




module.exports = router;
