const express = require("express");
const upload = require("../middlewares/upload.js");
const fs = require('fs');
const router = express.Router();
const imageController = require("../controllers/imageController");

router.put("/:id", async (req, res) => {
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

});

router.delete("/remove/:id", imageController.deleteImage, (req, res) => {
    res.json(res.statusCode);
});

module.exports = router;