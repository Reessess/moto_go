const express = require('express');
const { getBikes } = require('../controllers/bikeController');
const router = express.Router();

router.get('/', getBikes);


module.exports = router;
