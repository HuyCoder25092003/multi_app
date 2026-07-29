require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const port = process.env.PORT || 3000;

const app = express();

const db = "mongodb+srv://bomehuytai:bomehuytai1@cluster0.riorlwk.mongodb.net/?appName=Cluster0"


app.use(express.urlencoded({
  extended: true
}));

app.use(express.json());

app.use(cors()); // enable cors for all routes and origin

var auth = require("./API/routes/auth");
app.use(auth);

var banner = require("./API/routes/banner");
app.use(banner);

var category = require("./API/routes/category");
app.use(category);

var subCategory = require("./API/routes/sub_category");
app.use(subCategory);

var product = require("./API/routes/product");
app.use(product);

var productReview = require("./API/routes/product_review");
app.use(productReview);

var vendor = require("./API/routes/vendor");
app.use(vendor);

var order = require("./API/routes/order");
app.use(order);

mongoose.connect(db)
.then(() => {
    console.log("✅ MongoDB Connected");

    app.listen(port, "0.0.0.0", () => {
        console.log(`🚀 Server running at http://localhost:${port}`);
    });
})
.catch(err => {
    console.error(err);
});
