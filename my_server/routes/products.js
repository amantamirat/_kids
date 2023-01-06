const express = require("express");
const router = express.Router();
const productController = require("../controllers/productController");

router.post('/new/:category_id/:type_id/:brand_id', productController.createProduct);

router.patch('/update/:category_id/:type_id/:brand_id/:id', productController.editProduct);

router.delete('/delete/:category_id/:type_id/:brand_id/:id', productController.deleteProduct);


module.exports = router;