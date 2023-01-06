const express = require("express");
const router = express.Router();
const brandController = require("../controllers/brandController");

router.post('/new/:category_id/:type_id', brandController.createBrand);

router.patch("/update/:category_id/:type_id/:id", brandController.editBrand);

router.delete("/delete/:category_id/:type_id/:id", brandController.deleteBrand);

module.exports = router;