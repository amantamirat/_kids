const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");

router.get("/", userController.findAll);

router.post('/new', userController.createUser);

router.patch("/update/:id", userController.editUser);

router.delete("/delete/:id", userController.deleteUser);

module.exports = router;