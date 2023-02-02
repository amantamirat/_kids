const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema(
    {
        first_name: {
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
        verification_code: {
            type: String,
            default: null
        }
    }
);


const User = mongoose.model('User', UserSchema);

module.exports = User;