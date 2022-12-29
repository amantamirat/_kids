const express = require("express");
const upload = require("../middlewares/upload.js");
const fs = require('fs');
const router = express.Router();

router.put("/:id", async (req, res) => {
    let exists = fs.existsSync('../files/' + req.params.id);
    if (exists) {
        fs.rename('files/' + req.params.id, 'files/' + req.params.id + '_2');
    }
    upload(req, res, async function (err) {
        if (err) {
            if (exists) {
                fs.rename('files/' + req.params.id + "_2", 'files/' + req.params.id);
            }
            console.log(err);
        } else {
            if (exists) {
                fs.unlink('files/' + req.params.id + "_2", (err) => {
                    if (err) {
                        throw err;
                    }
                });
            }
        }
    });

});

module.exports = router;