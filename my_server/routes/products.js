const express = require("express");
const router = express.Router();
const Category = require("../models/Category");


router.post('/new/category/:category_id/type/:type_id', async (req, res) => {
    try {

        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product = req.body;

        await Category.findByIdAndUpdate(category_id,
            { $set: { 'clothing_types.$[type]': product } },
            { arrayFilters: [{ 'type._id': type_id }] });
        
        res.status(201).json({
            status: 'Success',
            type: type
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Product',
            message: err
        })
    }
});

router.patch('/update/category/:category_id/type/:type_id/:product_id', async (req, res) => {
    try {

        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const product_id = req.params.product_id;
        const product = req.body;



        
        res.status(201).json({
            status: 'Success',
            type: type
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Clothing Type',
            message: err
        })
        console.log(err)
    }
});

router.delete('/delete/category/:category_id/:type_id', async (req, res) => {
    try {
        await Category.findByIdAndUpdate(req.params.category_id,
            { $pull: { clothing_types: { _id: req.params.type_id } } },
            { new: true, runValidators: true }
        );
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