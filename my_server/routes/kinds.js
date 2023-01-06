const express = require("express");

const router = express.Router();

const kindController = require("../controllers/kindController");

router.post('/new/:category_id/:type_id/:brand_id/:product_id', kindController.createKind);

router.patch('/update/:category_id/:type_id/:brand_id/:product_id/:id', kindController.editKind);

router.delete('/delete/:category_id/:type_id/:brand_id/:product_id/:id', kindController.deleteKind);

module.exports = router;