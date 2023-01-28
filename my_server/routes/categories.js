const express = require("express");
const router = express.Router();
const categoryController = require("../controllers/categoryController");
const auth = require("../middlewares/auth");

router.get("/", categoryController.findAll);

router.post('/new', auth, categoryController.createCategory);

router.patch("/update/:id", auth, categoryController.editCategory);

router.delete("/delete/:id", auth, categoryController.deleteCategory);

module.exports = router;