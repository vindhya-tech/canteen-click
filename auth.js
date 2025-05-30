const express = require('express');
const router = express.Router();
const { signup, login } = require('../controllers/authController');

// Route for student signup
router.post('/signup', signup);

// Route for login (both student and staff)
router.post('/login', login);

module.exports = router;
