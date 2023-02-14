const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");
const orderController = require("../controllers/orderController");
const auth = require("../middlewares/auth");
const verifyAdmin = require("../middlewares/verifyAdmin");

//router.get("/", auth, verifyAdmin, userController.findAll);

router.get("/",  userController.findAll);

router.post('/register', userController.registerUser);

router.post('/verify', userController.verify);

router.post('/sendCode', userController.sendCode);

router.post('/login', userController.loginUser);

router.post('/changePassword/:id', auth, userController.changePassword);

router.patch("/update/:id", auth, userController.editUser);

router.delete("/delete/:id", auth, userController.deleteUser);

router.post("/placeOrders/:id", auth, orderController.checkOrder, orderController.placeOrders, orderController.updateInventory);

router.get("/findOrders/:id", auth, orderController.findOrders);

module.exports = router;