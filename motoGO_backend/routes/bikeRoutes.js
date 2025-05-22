const express = require('express');
const bikeController = require('../controllers/bikeController'); // <-- make sure this line is here
const router = express.Router();

router.get('/', bikeController.getBikes);
router.post('/', bikeController.addBikes);

module.exports = router;
