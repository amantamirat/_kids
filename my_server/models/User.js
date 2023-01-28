const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema(
    {
        first_name: {
            type: String,
        },
        middle_name: {
            type: String,
        },
        last_name: {
            type: String,
        },
        email: {
            type: String,
            required: true,
            unique: true
        },
        phone_number: {
            type: String,
            unique: true
        },
        address: {
            type: String,
        },
        user_name: {
            type: String,
            unique: true
        },
        password: {
            type: String,
            required: true
        },
        token: {
            type: String,
            default: null
        },
        user_status: {
            type: String,
            default: 'Pending',
            enum: ['Pending', 'Verified', 'Blocked']
        },
        role: {
            type: String,
            default: 'Customer',
            enum: ['Customer', 'Administrator']
        },
    }
);


const User = mongoose.model('User', UserSchema);

module.exports = User;