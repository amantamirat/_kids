const Category = require("../models/Category");
const imageController = require("./imageController");

exports.findAll = async (req, res, next) => {
    try {
        const categories = await Category.find({});
        await init(categories.length);
        res.status(200).json({
            status: "Success",
            categories: categories
        });
    } catch (err) {
        return res.status(500).json({
            status: "Failed to retrieve categories",
            message: err,
        });
    }
}


exports.createCategory = async (req, res, next) => {
    try {
        const category = await Category.create(req.body);
        await category.save();
        res.status(201).json({
            status: 'Success',
            data: category

        })
    } catch (err) {
        res.status(500).json({
            status: 'Failed to create department',
            message: err
        })
    }
}

exports.editCategory = async (req, res, next) => {
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
}


exports.deleteCategory = async (req, res, next) => {
    try {
        await Category.findByIdAndDelete(req.params.id);
        await imageController.deleteImage(req, res);
        res.status(204).json({
            status: "Success",
            data: {},
        });
    } catch (err) {
        return res.status(500).json({
            status: "Failed to Delete Category",
            message: err,
        });
    }
}


async function init(length) {
    if (length === 0) {
        let categories = [
            {
                title: "Boys", description: "a collection of clothes for boys ...."
                , clothing_types: [
                    { type: "Jeans" },
                    { type: "Trousers" },
                    { type: "T-shirt" },
                    { type: "Shirts" },
                    { type: "Shoes" }
                ]
            },
            {
                title: "Girls", description: "a collection of clothes for girls including tights, skirts ....",
                clothing_types: [
                    { type: "Shorts" },
                    { type: "Tights" },
                    { type: "Dress" },
                    { type: "Heels" },
                    { type: "Swim Dress" }
                ]
            },
            {
                title: "Babies", description: "a collection of clothes for babies ....",
                clothing_types: [
                    { type: "Socks" },
                    { type: "Diapers" },
                    { type: "Baby Hat" },
                    { type: "Sweaters" }
                ]
            }
        ];
        await Category.insertMany(categories);
    }
}



