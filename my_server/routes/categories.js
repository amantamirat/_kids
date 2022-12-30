const express = require("express");
const Category = require("../models/Category");
const upload = require("../middlewares/upload.js");
const fs = require('fs');
const router = express.Router();

router.get("/", async (req, res) => {
  //console.log("Request recieved");
  const categories = await Category.find({});
  await init(categories.length);
  try {
    res.status(200).json({
      status: "Success",
      categories: categories
    });
  } catch (err) {
    res.status(500).json({
      status: "Failed to retrieve categories",
      message: err,
    });
  }
});

router.get("/:id", getCategory, (req, res) => {
  res.json(res.category);
});


router.post('/new', async (req, res) => {
  const category = await Category.create(req.body);
  try {
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
  //console.log("Request recieved => category update "+req.params.id)
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

router.delete("/delete/:id", async (req, res) => {
  //console.log("delete requested");
  await Category.findByIdAndDelete(req.params.id);
  try {
    res.status(204).json({
      status: "Success",
      data: {},
    });
  } catch (err) {
    res.status(500).json({
      status: "Failed to Delete Category",
      message: err,
    });
  }
});

async function getCategory(req, res, next) {
  let category;
  try {
    category = await Category.findById(req.params.id);
    if (category == null) {
      return res.status(404).json({ message: "Cannot find category" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }

  res.category = category;
  next();
}

async function init(length) {
  if (length === 0) {
    categories = [
      { title: "Boys", description: "a collection of clothes for boys ...."},
      { title: "Girls", description: "a collection of clothes for girls including tights, skirts ...."},
      { title: "Babies", description: "a collection of clothes for babies ...."}
    ];
    await Category.insertMany(categories);
  }
}



module.exports = router;