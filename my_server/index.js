const express = require("express");
const cors = require("cors");
const mongoose = require('mongoose');
const multer = require("multer");
const upload = multer();
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(upload.array()); 
app.use("/files", express.static('files'));

mongoose.set('strictQuery', false);

mongoose.connect(process.env.MONGO_URL, {
  UseNewUrlParser : true,
  UseUnifiedTopology:true
}).then(()=>{
  console.log('Database connection established...');
});

const categoryRouter = require("./routes/categories");
app.use("/categories", categoryRouter);


app.listen(process.env.PORT,  () => {
  console.log(`Abdu Kids Server is up and running on PORT ${process.env.PORT}...`);
});