const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");
const auth = require("../middlewares/auth");
const verifyAdmin = require("../middlewares/verifyAdmin");

router.get("/", auth, verifyAdmin, userController.findAll);

router.post('/register', userController.registerUser);

router.post('/login', userController.loginUser);

router.post('/sendCode', userController.sendCode);

router.post('/verify', userController.verify);

router.post('/changePassword/:id', auth, userController.changePassword);

router.patch("/update/:id", auth, userController.editUser);

router.delete("/delete/:id", auth, userController.deleteUser);

module.exports = router;