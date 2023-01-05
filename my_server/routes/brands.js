const express = require("express");
const router = express.Router();
const brandController = require("../controllers/brandController");

router.get("/", brandController.findAll);

router.post('/new', brandController.createBrand);

router.patch("/update/:id", brandController.editBrand);

router.delete("/delete/:id", brandController.deleteBrand);

module.exports = router;