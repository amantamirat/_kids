const verifyAdmin = (req, res, next) => {
    if (!req.user) {
        return res.status(403).json({
            status: 'Error',
            message: 'A token is required for authentication',
        });
    }
    if (req.user.role != "Administrator") {
        return res.status(403).json({
            status: 'Error',
            message: 'Auth Failed!',
        });

    }
    return next();
};

module.exports = verifyAdmin;