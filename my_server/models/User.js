const mongoose = require('mongoose')

const bcrypt = require('bcrypt')

const UserSchema = new mongoose.Schema(
    {
        username: {
            type: String,
            required: true,
            unique: true
        },
        password: {
            type: String,
            required: true
        },
        email: {
            type: String,
            unique: true
        },
        role: {
            type: String,
            default: 'Customer',
            enum: ['Customer', 'Administrator']
        },
    }
);

UserSchema.statics.register = async function (user) {
    const exist = this.exists({ username: user.username });

    if (exist === true) {
        throw Error("username already exist! " + user.username);
    }

    const salt = await bcrypt.genSalt(10);

    const hashed = await bcrypt.hash(user.password, salt);

    user = await this.create({ username: user.username, password: hashed, email: user.email, role: user.role });

    return user;
}

const User = mongoose.model('User', UserSchema);

module.exports = User;