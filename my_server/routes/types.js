const express = require("express");
const router = express.Router();
const typeController = require("../controllers/typeController");

router.post('/new/:category_id', typeController.createType);

router.patch('/update/:category_id/:id', typeController.editType);

router.delete('/delete/:category_id/:id', typeController.deleteType);

module.exports = router;