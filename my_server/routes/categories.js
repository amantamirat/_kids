const express = require("express");
const router = express.Router();
const categoryController = require("../controllers/categoryController");

router.get("/", categoryController.findAll);

router.get("/:id", categoryController.getCategory);

router.post('/new', categoryController.createCategory);

router.patch("/update/:id", categoryController.editCategory);

router.delete("/delete/:id", categoryController.deleteCategory);

module.exports = router;