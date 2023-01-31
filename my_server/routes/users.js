const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");
const auth = require("../middlewares/auth");

router.get("/", userController.findAll);

router.post('/register', userController.registerUser);

router.post('/login', userController.loginUser);

router.post('/changePassword/:id', auth,userController.changePassword);

router.patch("/update/:id", auth, userController.editUser);

router.delete("/delete/:id", auth, userController.deleteUser);

module.exports = router;