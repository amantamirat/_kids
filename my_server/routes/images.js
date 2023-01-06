const express = require("express");
const router = express.Router();
const imageController = require("../controllers/imageController");
router.put("/:id", imageController.uploadImage);
module.exports = router;