const mongoose = require('mongoose')

const CategorySchema = new mongoose.Schema(
    {
        title: {
            type: String,
            unique: true,
            required: true,
        },
        description: {
            type: String
        },
        clothing_types: [{
            type: {
                type: String,
            },
            brands: [{
                brand_name: {
                    type: String
                },
                products: [
                    {
                        product_description: {
                            type: String
                        },
                        size: {
                            type: Number,
                            min: 0
                        },
                        price: {
                            type: Number,
                            min: 0
                        },
                        product_kinds: [{
                            color: {
                                type: String
                            },
                            quantity: {
                                type: Number,
                                min: 0
                            }
                        }],
                    }
                ]
            }],
        }
        ]
    }
);


const Category = mongoose.model('Category', CategorySchema);

module.exports = Category;