const User = require("../models/User");

exports.findAll = async (req, res, next) => {
    try {
        const users = await User.find({});
        res.status(200).json({
            status: "Success",
            users: users
        });
    } catch (err) {
        return res.status(500).json({
            status: "Failed to retrieve users",
            message: err,
        });
    }
}


exports.createUser = async (req, res, next) => {
    try {
        const user = await User.create(req.body);
        await user.save();
        res.status(201).json({
            status: 'Success',
            data: user

        })
    } catch (err) {
        res.status(500).json({
            status: 'Failed to create user',
            message: err
        })
    }
}

exports.editUser = async (req, res, next) => {
    try {
        const updatedUser = await User.findByIdAndUpdate(
            req.params.id,
            req.body,
            {
                new: true,
                runValidators: true,
            }
        );
        res.status(201).json({
            status: "Success",
            data: updatedUser,
        });
    } catch (err) {
        res.status(500).json({
            status: "Failed to Update User",
            message: err,
        });
    }
}


exports.deleteUser = async (req, res, next) => {
    try {
        await User.findByIdAndDelete(req.params.id);
        //await imageController.deleteImage(req, res);
        res.status(204).json({
            status: "Success",
            data: {},
        });
    } catch (err) {
        return res.status(500).json({
            status: "Failed to Delete User",
            message: err,
        });
    }
}