const mongoose = require('mongoose')


const BrandSchema = new mongoose.Schema(
    {
        brand_name: {
            type: String,
            required: true,
            unique: true
        }
    }
);


const Brand = mongoose.model('Brand', BrandSchema);

module.exports = Brand;