const router = express.Router();
const Category = require("../models/Category");


router.post('/new/category/:category_id', async (req, res) => {
    try {
        const category = await Category.findById(req.params.category_id);
        var type = category['academic_curriculums'].create(req.body);
        category['clothing_types'].push(type);
        await category.save();
        res.status(201).json({
            status: 'Success',
            type: type
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Type',
            message: err
        })
    }
});

router.patch('/update/category/:category_id/:type_id', async (req, res) => {
    try {
        const type = await Category.findOneAndUpdate({ _id: req.params.category_id, 'clothing_types._id': req.params.type_id },
            { $set: { 'clothing_types.$.type': req.body.type } }, { new: true, runValidators: true });
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