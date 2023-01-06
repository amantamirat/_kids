const upload = require("../middlewares/upload.js");
const fs = require('fs');
exports.uploadImage = async (req, res, next) => {
    upload(req, res, async function (err) {
        if (err) {
            console.log(err);
        } else {
            res.status(201).json({
                status: "Success",
                data: "Image uploaded",
            });
        }
    });
}
exports.deleteImage = async (req, res, next) => {
    let path = 'files/' + req.params.id;
    let exists = fs.existsSync(path);
    if (exists) {
        fs.unlink(path, (err) => {
            if (err) {
                throw err;
            }
        });
    }
}