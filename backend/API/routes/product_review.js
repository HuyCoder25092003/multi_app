const express = require("express");
const ProductReview = require("../models/product_review");
const Product = require("../models/product");

var router = express.Router();

router.route("/api/product-review").post(async (req, res) => {
    try {

        const { buyerId, email, fullName, productId, rating, review } = req.body;
        
        const existingReviews = await ProductReview.findOne({buyerId, productId});

        if(existingReviews)
            return res.status(400).json({ msg: "You have already reviewed this product" }); 
        
        const reviews = new ProductReview({ buyerId, email, fullName, productId, rating, review });
        await reviews.save();

        const product = await Product.findById(productId);
        if (!product || product.length == 0)
            return res.status(404).json({ msg: "products not found" });
        else {
            product.totalRatings += 1;
            product.averageRating = ((product.averageRating * (product.totalRatings - 1)) + rating) / product.totalRatings;
            await product.save();
            return res.status(201).send(reviews);
        }


    } catch (e) {
        return res.status(500).json({ "error": e.message });
    }
})

router.route("/api/reviews").get(async (req, res) => {
    try {

        const reviews = await ProductReview.find();

        return res.status(200).send(reviews);

    } catch (e) {
        return res.status(500).json({ "error": e.message });
    }
})



module.exports = router;