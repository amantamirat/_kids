const express = require("express");

const Category = require("../models/Category");

const router = express.Router();

router.get("/", async (req, res) => {
  await init();
  const categories = await Category.find({});
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

router.post("/new", async (req, res) => {
  const category = new Category(req.body);
  try {
    await category.save();
    res.status(201).json({
      status: "Success",
      data: {
        category,
      },
    });
  } catch (err) {
    res.status(500).json({
      status: "Failed to create category",
      message: err,
    });
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

router.delete("/delete/:id", async (req, res) => {
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

async function init() {
  let categories = await Category.find({});
  if (categories.length === 0) {
    categories = [
      { title: "Boys", description: "a collection of clothes of boys ....", cat_image_url: "/catImages/boys.jpg" },
      { title: "Girls", description: "a collection of clothes of girls including tights, skirts ....", cat_image_url: "/catImages/girls.jpg" },
      { title: "Babies", description: "a collection of clothes of babies ....", cat_image_url: "/catImages/babies.jpg" }
    ];
    await Category.insertMany(categories);
  }
}



module.exports = router;