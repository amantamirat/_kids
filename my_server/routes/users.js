const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");
const auth = require("../middlewares/auth");

router.get("/", userController.findAll);

router.post('/new', userController.createUser);

router.post('/login', userController.loginUser);

router.patch("/update/:id", auth, userController.editUser);

router.delete("/delete/:id", auth, userController.deleteUser);

module.exports = router;