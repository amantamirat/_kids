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
        cat_image_url: {
            type: String
        }
    }
);


const Category = mongoose.model('Category', CategorySchema);

module.exports = Category;