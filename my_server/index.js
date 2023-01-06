const express = require("express");
const cors = require("cors");
const mongoose = require('mongoose');
const multer = require("multer");
const upload = multer({ dest: "files/" });
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/files", express.static('files'));
//app.use(upload.array()); 

mongoose.set('strictQuery', false);
mongoose.connect(process.env.MONGO_URL, {
  UseNewUrlParser: true,
  UseUnifiedTopology: true
}).then(() => {
  console.log('Database connection established...');
});

const brandRouter = require("./routes/brands");
app.use("/brands", brandRouter);
const categoryRouter = require("./routes/categories");
app.use("/categories", categoryRouter);
const typeRouter = require("./routes/types");
app.use("/types", typeRouter);
const productRouter = require("./routes/products");
app.use("/products", productRouter);
const kindRouter = require("./routes/kinds");
app.use("/kinds", kindRouter);

const uploadRouter = require("./routes/uploadImage");
app.use("/upload", uploadRouter);


app.listen(process.env.PORT, () => {
  console.log(`Abdu Kids Server is up and running on PORT ${process.env.PORT}...`);
});