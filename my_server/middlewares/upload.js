const multer = require("multer");
const Path = require('path');

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "./files");
    },
    filename: function (req, file, cb) {
        cb(null, req.params.id);
    },
});

const fileFilter = (req, file, callback) => {
    const acceptableExtensions = [".png", ".jpg", "jpeg", ".mp4"];
    if (!acceptableExtensions.includes(Path.extname(file.originalname))) {
        return callback(new Error("Only .png, .jpg and .jpeg format allowed!"));
    }

    const fileSize = parseInt(req.headers["content-length"]);
    if (fileSize > 5242880) {
        return callback(new Error("File Size Big"));
    }

    callback(null, true);
};

let upload = multer({
    storage: storage,
    fileFilter: fileFilter,
    fileSize: 5242880, // 5 Mb
});

module.exports = upload.single("image");