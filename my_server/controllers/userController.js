const User = require("../models/User");
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const nodemailer = require('nodemailer');

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

exports.registerUser = async (req, res, next) => {
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


        const sent = await sendEmail(req.body.email);
        if (sent === true) {
            const hashedcode = bcrypt.hash(code, salt);
            user.verification_code = hashedcode
            await user.save();
            delete user.password;
            delete user.verification_code;
            return res.status(201).json({
                status: 'Success',
                data: user
            });
        }
        return res.status(500).json({
            status: 'Failed to create user',
            message: err
        });
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

    if (user.user_status == "Blocked") {
        return res.status(400).json({
            status: 'Error',
            message: 'Account is Blocked, Contact Admin!',
        });
    }

    if (user.user_status == "Verified") {
        user.token = jwt.sign({ _id: user._id },
            process.env.TOKEN_KEY, {
            expiresIn: "2h",
        });
    }
    delete user.password;
    return res.status(201).json({
        status: 'Success',
        data: user
    })
}

exports.verify = async (req, res, next) => {
    let user = await User.findOne({ email: req.body.email });
    if (!user) {
        return res.status(400).json({
            status: 'Error',
            message: 'Incorrect, Account Is NOT Found.',
        });
    }

    const validCode = await bcrypt.compare(req.body.verification_code, user.verification_code);
    if (!validCode) {
        return res.status(400).json({
            status: 'Error',
            message: 'Incorrect Code.',
        });
    }
    user.user_status = "Verified";
    await user.save();
    user.token = jwt.sign({ _id: user._id },
        process.env.TOKEN_KEY, {
        expiresIn: "2h",
    });
    delete user.password;
    delete user.verification_code;
    return res.status(201).json({
        status: 'OK',
        data: user,
    });
}

exports.sendCode = async (req, res, next) => {
    let user = await User.findOne({ email: req.body.email });
    if (!user) {
        return res.status(400).json({
            status: 'Error',
            message: 'Incorrect, Account is Not Found.',
        });
    }
    const sent = await sendEmail(req.body.email);
    if (sent === true) {
        return res.status(201).json({
            status: 'Success',
            message: "Sent!"
        });
    }
    return res.status(400).json({
        status: 'Error',
        message: 'Not Sent, Contact Admin!',
    });

}

exports.changePassword = async (req, res, next) => {
    let user = await User.findById(req.params.id);
    if (!user) {
        return res.status(400).json({
            status: 'Error',
            message: 'Accound Not Fount',
        });
    }
    if (user.user_status != 'Verified') {
        return res.status(400).json({
            status: 'Error',
            message: 'Account is not Verified!',
        });
    }
    const validPassword = await bcrypt.compare(req.body.password, user.password);
    if (!validPassword) {
        return res.status(400).json({
            status: 'Error',
            message: 'Incorrect password.',
        });
    }

    const salt = await bcrypt.genSalt(10);
    const hashed = await bcrypt.hash(req.body.newPassword, salt);
    user.password = hashed;
    delete user.token;
    await user.save();
    delete user.password;
    return res.status(201).json({
        status: 'Success',
        data: user
    });
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


const sendEmail = async (email) => {
    try {
        const code = Math.floor(100000 + Math.random() * 900000);
        const subject = "Email Verification\n";
        const transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: process.env.USER,
                pass: process.env.PASS,
            }
        });
        const myOptions = {
            from: 'noreply@gmail.com',
            to: email,
            subject: subject,
            text: 'Hello,\n Welcome. Please Enter This Verfication Code to Activate Your Account.\n',
            html: '<h2>' + code + '</h2>'
        }

        transporter.sendMail(myOptions, function (error, info) {
            if (error) {
                console.log(error);
                return false;
            } else {
                console.log("Email Sent:" + info.response);
                return true;
            }
        });

    } catch (error) {
        console.log(error);
        return error;
    }
}