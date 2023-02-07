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
        },
        orders: [{
            total_quantity: {
                type: Number
            },
            total_price: {
                type: Number
            },
            order_date: {
                type: Date,
                default: Date.now
            },
            items: [{
                kind_id: {
                    type: mongoose.Schema.Types.ObjectId,                    
                },
                product_id: {
                    type: mongoose.Schema.Types.ObjectId,
                },
                brand_id: {
                    type: mongoose.Schema.Types.ObjectId,
                },
                type_id: {
                    type: mongoose.Schema.Types.ObjectId,
                },
                category_id: {
                    type: mongoose.Schema.Types.ObjectId,
                },
                brand: {
                    type: String
                },
                product_detail: {
                    type: String
                },
                product_size: {
                    type: Number
                },
                product_color: {
                    type: String
                },
                price: {
                    type: Number
                },
                quantity: {
                    type: Number
                }
            }],

        }]
    }
);


const User = mongoose.model('User', UserSchema);

module.exports = User;