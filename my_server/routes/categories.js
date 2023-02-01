const express = require("express");
const router = express.Router();
const categoryController = require("../controllers/categoryController");
const auth = require("../middlewares/auth");
const verifyAdmin = require("../middlewares/verifyAdmin");

router.get("/", categoryController.findAll);

router.post('/new', auth, verifyAdmin, categoryController.createCategory);

router.patch("/update/:id", auth, verifyAdmin, categoryController.editCategory);

router.delete("/delete/:id", auth, verifyAdmin, categoryController.deleteCategory);

module.exports = router;