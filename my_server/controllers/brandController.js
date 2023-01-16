const Category = require("../models/Category");
const imageController = require("./imageController");

exports.createBrand = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        let brand = req.body;
        const category = await Category.findById(category_id);
        let types = category.clothing_types;
        for (let i = 0; i < types.length; i++) {
            if (types[i]._id.toString() === type_id) {
                brand = types[i]['brands'].create(brand);
                types[i]['brands'].push(brand);
                await category.save();
                return res.status(201).json({
                    status: 'Success',
                    data: brand
                });
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

exports.editBrand = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const brand_id = req.params.id;
        const brand = req.body;
        await Category.updateOne({ _id: category_id },
            { $set: { 'clothing_types.$[t].brands.$[b]': brand } },
            { arrayFilters: [{ 't._id': type_id }, { 'b._id': brand_id }] });
        res.status(201).json({
            status: 'Success',
            data: brand
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Brand',
            message: err
        })
        //console.log(err)
    }
}

exports.deleteBrand = async (req, res, next) => {
    try {
        const category_id = req.params.category_id;
        const type_id = req.params.type_id;
        const brand_id = req.params.id;

        await Category.findByIdAndUpdate(category_id,
            { $pull: { 'clothing_types.$[t].brands': { _id: brand_id } } },
            { arrayFilters: [{ 't._id': type_id }] });

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






