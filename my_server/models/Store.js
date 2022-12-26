const mongoose = require('mongoose')


const StoreSchema = new mongoose.Schema(
    {
        category: {
            type: String,
            required: true,
            unique: true
        },
        brands: [{
            brand: {
                type: String,
                required: true,
            },
            items: [
                {
                    item: {
                        type: String
                    }

                }
            ]
        }
        ]
    }
);


const Store = mongoose.model('Store', StoreSchema);

module.exports = Store;