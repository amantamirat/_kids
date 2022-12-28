const express = require("express");

const Category = require("../models/Category");

const upload = require("../middlewares/upload.js");

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
  console.log(req);
  upload(req, res, async function (err) {
    if (err) {
      next(err);
    } else {
      const path =
        req.file != undefined ? req.file.path.replace(/\\/g, "/") : "";

      const category = new Category({
        title: req.body.title,
        description: req.body.description,
        image_url: path
      });
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


      /*
            const url = req.protocol + "://" + req.get("host");
      
            const path =
              req.file != undefined ? req.file.path.replace(/\\/g, "/") : "";
      
            var model = {
              title: req.body.title,
              description: req.body.description,
            };
      
            productsServices.createProduct(model, (error, results) => {
              if (error) {
                return next(error);
              }
              return res.status(200).send({
                message: "Success",
                data: results,
              });
            });
      */

    }
  });

  /*
  */

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
      { title: "Boys", description: "a collection of clothes of boys ....", image_url: "/catImages/boys.jpg" },
      { title: "Girls", description: "a collection of clothes of girls including tights, skirts ....", image_url: "/catImages/girls.jpg" },
      { title: "Babies", description: "a collection of clothes of babies ....", image_url: "/catImages/babies.jpg" }
    ];
    await Category.insertMany(categories);
  }
}



module.exports = router;