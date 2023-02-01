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

mongoose.set('strictQuery', false);
mongoose.connect(process.env.MONGO_URL, {
  UseNewUrlParser: true,
  UseUnifiedTopology: true
}).then(() => {
  console.log('Database connection established...');
});


const userRouter = require("./routes/users");
app.use("/users", userRouter);
const categoryRouter = require("./routes/categories");
app.use("/categories", categoryRouter);
const typeRouter = require("./routes/types");
app.use("/types", typeRouter);
const brandRouter = require("./routes/brands");
app.use("/brands", brandRouter);
const productRouter = require("./routes/products");
app.use("/products", productRouter);
const kindRouter = require("./routes/kinds");
app.use("/kinds", kindRouter);

const imageRouter = require("./routes/images");
app.use("/upload", imageRouter);


const comp = async()=>{
  const bcrypt = require('bcryptjs');
  const salt = await bcrypt.genSalt(10);
  const hashed = await bcrypt.hash("1234", salt);
  console.log(hashed);
} 

app.listen(process.env.PORT, () => {
  console.log(`Abdu Kids Server is up and running on PORT ${process.env.PORT}...`);
});

