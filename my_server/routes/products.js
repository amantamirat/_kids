const express = require("express");
const router = express.Router();
const Category = require("../models/Category");

router.post('/new/:category_id/:type_id', async (req, res) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        let product = req.body;
        const category = await Category.findById(category_id);
        
        let types = category.clothing_types;
        for (let i = 0; i < types.length; i++) {
            if (types[i]._id.toString() === type_id) {
                product = types[i]['products'].create(product);
                types[i]['products'].push(product);
                await category.save();
                return res.status(201).json({
                    status: 'Success',
                    product: product
                });
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
});

router.patch('/update/:category_id/:type_id/:product_id', async (req, res) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product_id = req.params.product_id;
        const product = req.body;
        
        await Category.updateOne({ _id: category_id },
            { $set: { 'clothing_types.$[t].products.$[p]': product } },
            { arrayFilters: [{ 't._id': type_id }, { 'p._id': product_id }] });
        res.status(201).json({
            status: 'Success',
            product: product
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Product',
            message: err
        })
        console.log(err)
    }
});

router.delete('/delete/:category_id/:type_id/:product_id', async (req, res) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product_id = req.params.product_id;

        await Category.findByIdAndUpdate(category_id,
            { $pull: { 'clothing_types.$[t].products.$[p]': { _id: product_id } } },
            { arrayFilters: [{ 't._id': type_id }] });

        res.status(204).json({
            status: 'Success',
        });
    } catch (err) {
        res.status(500).json({
            status: 'Failed to Delete Type',
            message: err
        })
        console.log(err)
    }
});

module.exports = router;