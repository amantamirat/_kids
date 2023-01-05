const fs = require('fs');
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