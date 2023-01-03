const express = require("express");
const Category = require("../models/Category");
const upload = require("../middlewares/upload.js");
const fs = require('fs');
const router = express.Router();
const categoryController = require("../controllers/categoryController");

router.get("/", categoryController.findAll, (req, res) => {
  res.json(res.categories);
});

router.get("/:id", categoryController.getCategory, (req, res) => {
  res.json(res.category);
});


router.post('/new', async (req, res) => {
  try {
    const category = await Category.create(req.body);
    await category.save();
    res.status(201).json({
      status: 'Success',
      data:
        category

    })
  } catch (err) {
    res.status(500).json({
      status: 'Failed to create department',
      message: err
    })
  }
});


router.patch("/update/:id", async (req, res) => {
  try {
    const updatedCategory = await Category.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true,
      }
    );
    res.status(201).json({
      status: "Success",
      data: updatedCategory,
    });
  } catch (err) {
    res.status(500).json({
      status: "Failed to Update Category",
      message: err,
    });
  }
});

router.delete("/delete/:id", categoryController.deleteCategory, async (req, res) => {
  res.json(res.statusCode);
});

module.exports = router;