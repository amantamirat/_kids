const Category = require("../models/Category");
const imageController = require("./imageController");

exports.createKind = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product_id = req.params.product_id;
        let kind = req.body;
        const category = await Category.findById(category_id);
        let types = category.clothing_types;
        for (let i = 0; i < types.length; i++) {
            if (types[i]._id.toString() === type_id) {
                let products = types[i].products;
                for (let j = 0; j < products.length; j++) {
                    let products = types[i].products;
                    if (products[j]._id.toString() === product_id) {
                        kind = products[j]['product_colors'].create(kind);
                        products[j]['product_colors'].push(kind);
                        await category.save();
                        return res.status(201).json({
                            status: 'Success',
                            kind: kind
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
            status: 'Failed to Update Product',
            message: err
        })
        console.log(err);
    }
}

exports.editKind = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product_id = req.params.product_id;
        const kind_id = req.params.kind_id;
        const kind = req.body;
        await Category.updateOne({ _id: category_id },
            { $set: { 'clothing_types.$[t].products.$[p].product_colors.$[k]': kind } },
            { arrayFilters: [{ 't._id': type_id }, { 'p._id': product_id }, { 'k._id': kind_id }] });
        res.status(201).json({
            status: 'Success',
            kind: kind
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Product',
            message: err
        })
        // console.log(err)
    }
}


exports.deleteKind = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product_id = req.params.product_id;
        const kind_id = req.params.id;

        await Category.findByIdAndUpdate(category_id,
            { $pull: { 'clothing_types.$[t].products.$[p].product_colors': { _id: kind_id } } },
            { arrayFilters: [{ 't._id': type_id }, { 'p._id': product_id }] });

        await imageController.deleteImage(req, res);

        res.status(204).json({
            status: 'Success',
        });
    } catch (err) {
        res.status(500).json({
            status: 'Failed to Delete Type',
            message: err
        })
        //console.log(err)
    }
}

