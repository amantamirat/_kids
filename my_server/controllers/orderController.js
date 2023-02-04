const User = require("../models/User");
exports.orderItems = async (req, res, next) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) {
            res.status(205).json({
                status: 'Failed',
                message: 'User Not Found!'
            })
        }
        let order = req.body;
        console.log(order);
        let items = order.items;
        for (let i = 0; i < items.length; i++) {
            console.log(items[i]);
        }
        //console.log(orders);
        //user['orders'].push(order);
        //await category.save();
        res.status(201).json({
            status: 'Success',
            data: order
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Type',
            message: err
        })
    }
}

exports.checkItems = async (req, res, next) => {
    try {
        const user = await User.findById(req.params.user_id);
        let order = user['orders'].create(req.body);
        user['orders'].push(order);
        await category.save();
        res.status(201).json({
            status: 'Success',
            data: order
        });
    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Type',
            message: err
        })
    }
}