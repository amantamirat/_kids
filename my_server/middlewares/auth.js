const jwt = require("jsonwebtoken");
require('dotenv').config();

const verifyToken = (req, res, next) => {
    const token =
        req.body.token || req.query.token || req.headers["x-access-token"];

    if (!token) {
        return res.status(403).json({
            status: 'Error',
            message: 'A token is required for authentication',
        });
    }
    try {
        const decoded = jwt.verify(token, process.env.TOKEN_KEY);
        req.user = decoded;
    } catch (err) {
        return res.status(401).json({
            status: 'Error',
            message: 'Invalid token!',
        });
    }
    return next();
};

module.exports = verifyToken;