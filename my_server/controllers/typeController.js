const Category = require("../models/Category");
const imageController = require("./imageController");


exports.createType = async (req, res, next) => {
    try {
        const category = await Category.findById(req.params.category_id);
        let type = category['clothing_types'].create(req.body);
        category['clothing_types'].push(type);
        await category.save();
        res.status(201).json({
            status: 'Success',
            data: type
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Type',
            message: err
        })
    }
}

exports.editType = async (req, res, next) => {
    try {
        const type = await Category.findOneAndUpdate({ _id: req.params.category_id, 'clothing_types._id': req.params.id },
            { $set: { 'clothing_types.$.type': req.body.type } }, { new: true, runValidators: true });
        res.status(201).json({
            status: 'Success',
            data: type
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Clothing Type',
            message: err
        })
        //console.log(err)
    }
}

exports.deleteType = async (req, res, next) => {
    try {
        await Category.findByIdAndUpdate(req.params.category_id,
            { $pull: { clothing_types: { _id: req.params.id } } },
            { new: true, runValidators: true }
        );
        await imageController.deleteImage(req, res);
        res.status(204).json({
            status: 'Success',
        });
    } catch (err) {
        res.status(500).json({
            status: 'Failed to Delete Type',
            message: err
        });
    }
}




