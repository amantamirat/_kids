const User = require("../models/User");
const bcrypt = require('bcrypt');
require('dotenv').config();

exports.createUser = async (req, res, next) => {
    try {
        if (!req.body.email || !req.body.password) {
            return res.status(400).json({
                status: 'Error',
                message: 'All input are required!',
            });
        }
        let user = await User.findOne({ email: req.body.email });
        if (user) {
            return res.status(400).json({
                status: 'Error',
                message: 'The user email already registred!',
            });
        }
        const salt = await bcrypt.genSalt(10);
        const hashed = await bcrypt.hash(req.body.password, salt);
        user = await User.create({
            email: req.body.email,
            password: hashed
        });
        await user.save();
        user.token = jwt.sign({ _id: user._id },
            process.env.TOKEN_KEY, {
            expiresIn: "2h",
        });
        return res.status(201).json({
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

exports.loginUser = async (req, res, next) => {
    let user = await User.findOne({ email: req.body.email });
    if (!user) {
        return res.status(400).json({
            status: 'Error',
            message: 'Incorrect email or password.',
        });
    }
    const validPassword = await bcrypt.compare(req.body.password, user.password);
    if (!validPassword) {
        return res.status(400).json({
            status: 'Error',
            message: 'Incorrect email or password.',
        });
    }
    user.token = jwt.sign({ _id: user._id },
        process.env.TOKEN_KEY, {
        expiresIn: "2h",
    });
    return res.status(201).json({
        status: 'Success',
        data: user
    })
}


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