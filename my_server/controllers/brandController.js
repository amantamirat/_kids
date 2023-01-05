const Brand = require("../models/Brand");
const imageController = require("./imageController");

exports.findAll = async (req, res, next) => {
    try {
        const brands = await Brand.find({});
        res.status(200).json({
            status: "Success",
            brands: brands
        });
    } catch (err) {
        return res.status(500).json({
            status: "Failed to retrieve brands",
            message: err,
        });
    }
}


exports.createBrand = async (req, res, next) => {
    try {
        const brand = await Brand.create(req.body);
        await brand.save();
        res.status(201).json({
            status: 'Success',
            data: brand
        })
    } catch (err) {
        res.status(500).json({
            status: 'Failed to create brand',
            message: err
        })
    }
}

exports.editBrand = async (req, res, next) => {
    try {
        const updatedBrand = await Brand.findByIdAndUpdate(
            req.params.id, req.body,
            {
                new: true,
                runValidators: true,
            }
        );
        res.status(201).json({
            status: "Success",
            data: updatedBrand,
        });
    } catch (err) {
        res.status(500).json({
            status: "Failed to Update Brand",
            message: err,
        });
    }
}


exports.deleteBrand = async (req, res, next) => {
    try {
        await Brand.findByIdAndDelete(req.params.id);
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






