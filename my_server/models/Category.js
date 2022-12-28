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
        image_url: {
            type: String
        },
        clothing_types: [{
            type: {
                type: String,
            },
            sample_image_url: {
                type: String
            },
            products: [
                {
                    product_name: {
                        type: String
                    },
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
                    product_colors: [{
                        color: {
                            type: String
                        },
                        quantity: {
                            type: Number,
                            min: 0
                        },
                        product_image_url: {
                            type: String
                        }
                    }],
                }
            ]
        }
        ]
    }
);


const Category = mongoose.model('Category', CategorySchema);

module.exports = Category;