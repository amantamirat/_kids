const mongoose = require('mongoose')


const ItemSchema = new mongoose.Schema(
    {
        item_name: {
            type: String,
            required: true,
            unique: true
        }
    }
);


const Item = mongoose.model('Item', ItemSchema);

module.exports = Item;