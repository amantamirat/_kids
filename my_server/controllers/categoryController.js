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

exports.getCategory = async (req, res, next) => {
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



