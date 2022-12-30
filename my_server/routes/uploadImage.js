const express = require("express");
const upload = require("../middlewares/upload.js");
const fs = require('fs');
const router = express.Router();

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

router.delete("/remove/:id", async (req, res) => {
    let path = 'files/' + req.params.id;
    let exists = fs.existsSync(path);
    if (exists) {
        fs.unlink(path, (err) => {
            if (err) {
                throw err;
            }
            else {
                res.status(201).json({
                    status: "Success",
                    msg: "Removed",
                });
            }
        });
    } else {
        res.status(404).json({
            status: "Success",
            data: "Not Found!",
        });
    }
});

module.exports = router;