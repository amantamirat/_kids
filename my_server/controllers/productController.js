const Category = require("../models/Category");
const imageController = require("./imageController");

exports.createProduct = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const brand_id = req.params.brand_id;
        let product = req.body;
        const category = await Category.findById(category_id);
        let types = category.clothing_types;
        for (let i = 0; i < types.length; i++) {
            if (types[i]._id.toString() === type_id) {
                let brands = types[i].brands;
                for (let j = 0; j < brands.length; j++) {
                    if (brands[j]._id.toString() === brand_id) {
                        product = brands[j]['products'].create(product);
                        brands[j]['products'].push(product);
                        await category.save();
                        return res.status(201).json({
                            status: 'Success',
                            data: product
                        });
                    }
                }
            }
        }
        return res.status(404).json({
            status: 'Not Found',
            msg: "Not Found"
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Create Brand!',
            message: err
        })
        //console.log(err);
    }
}

exports.editProduct = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const brand_id = req.params.brand_id;
        const product_id = req.params.id;
        const product = req.body;
        await Category.updateOne({ _id: category_id },
            { $set: { 'clothing_types.$[t].brands.$[b].products.$[p]': product } },
            { arrayFilters: [{ 't._id': type_id }, { 'b._id': brand_id }, { 'p._id': product_id }] });
        res.status(201).json({
            status: 'Success',
            data: product
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Brand',
            message: err
        })
        //console.log(err)
    }
}

exports.deleteProduct = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const brand_id = req.params.brand_id;
        const product_id = req.params.id;

        await Category.findByIdAndUpdate(category_id,
            { $pull: { 'clothing_types.$[t].brands.$[b].products': { _id: product_id } } },
            { arrayFilters: [{ 't._id': type_id }, { 'b._id': brand_id }] });

        await imageController.deleteImage(req, res);

        res.status(204).json({
            status: 'Success',
        });
    } catch (err) {
        res.status(500).json({
            status: 'Failed to Delete Brand',
            message: err
        })
    }
}