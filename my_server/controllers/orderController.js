const Category = require("../models/Category");
const User = require("../models/User");

exports.checkOrder = async (req, res, next) => {
    try {
        if (!req.params.id) {
            res.status(405).json({
                status: 'Error',
                message: 'Failed to Check Orders'
            })
        }
        let order = req.body;
        let total_price = 0;
        let total_quantity = 0;
        let items = order.items;
        for (let i = 0; i < items.length; i++) {
            let item = items[i];
            total_price = total_price + (item.price * item.quantity);
            total_quantity = total_quantity + item.quantity;
            let category = await Category.findById(item.category_id);
            let types = category.clothing_types;
            for (let t = 0; t < types.length; t++) {
                if (types[t]._id.toString() === item.type_id) {
                    let brands = types[t].brands;
                    for (let b = 0; b < brands.length; b++) {
                        if (brands[b]._id.toString() === item.brand_id) {
                            let products = brands[b].products;
                            for (let p = 0; p < products.length; p++) {
                                if (products[p]._id.toString() === item.product_id) {
                                    let product = products[p];
                                    if (product.price != item.price) {
                                        //console.log("price mismatch");
                                        return res.status(403).json({
                                            status: 'Error',
                                            message: product.product_detail + " price is not equal!",
                                        });
                                    }
                                    if (item.quantity % product.minimum_order_quanity != 0) {
                                        //console.log("moq mismatch");
                                        return res.status(403).json({
                                            status: 'Error',
                                            message: item.quantity + "is not a modular of the moq which is" + product.minimum_order_quanity,
                                        });
                                    }
                                    let kinds = product.product_kinds;
                                    for (let k = 0; k < kinds.length; k++) {
                                        if (kinds[k]._id.toString() === item.kind_id) {
                                            let kind = kinds[k];
                                            if (kind.quantity < item.quantity) {
                                                //console.log("store quantity mismatch");
                                                return res.status(403).json({
                                                    status: 'Error',
                                                    message: product.product_detail + " " + kind.color + " quantity is not avialiable in the store",
                                                });
                                            }
                                            item.brand = brands[b].brand_name;
                                            item.product_detail = product.product_detail;
                                            item.product_size = product.size;
                                            item.product_color = kind.color;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if (total_price != order.total_price || total_quantity != order.total_quantity) {
            //console.log("total mismatch");
            return res.status(403).json({
                status: 'Error',
                message: "total price or total quantity is not matched!",
            });
        }
        return next();
    } catch (err) {
        //console.log(err);
        return res.status(403).json({
            status: 'Error',
            message: err,
        });
    }
}

exports.placeOrders = async (req, res, next) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) {
            return res.status(205).json({
                status: 'Failed',
                message: 'User Not Found!'
            });
        }
        //console.log(req.body);
        let order = user['orders'].create(req.body);
        user['orders'].push(order);
        await user.save();
        return next();
    } catch (err) {
        console.log(err);
        return res.status(205).json({
            status: 'Failed to Place Orders',
            message: err
        })
    }
}

exports.updateInventory = async (req, res, next) => {
    try {
        let items = req.body.items;
        for (let i = 0; i < items.length; i++) {
            let item = items[i];
            let category = await Category.findById(item.category_id);
            let types = category.clothing_types;
            for (let t = 0; t < types.length; t++) {
                if (types[t]._id.toString() === item.type_id) {
                    let brands = types[t].brands;
                    for (let b = 0; b < brands.length; b++) {
                        if (brands[b]._id.toString() === item.brand_id) {
                            let products = brands[b].products;
                            for (let p = 0; p < products.length; p++) {
                                let product = products[p];
                                if (product._id.toString() === item.product_id) {
                                    let kinds = product.product_kinds;
                                    for (let k = 0; k < kinds.length; k++) {
                                        let kind = kinds[k];
                                        if (kind._id.toString() === item.kind_id) {
                                            kind.quantity = kind.quantity - item.quantity;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            await category.save();
        }
        res.status(201).json({
            status: 'Success',
            data: req.body
        });

    } catch (err) {
        res.status(205).json({
            status: 'Failed to Update Inventory',
            message: err
        })
    }
}