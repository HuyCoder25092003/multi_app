const express = require("express");
const Product = require("../models/product");
const { auth, vendorAuth } = require("../middleware/auth");
const subCategory = require("../models/sub_category");

var router = express.Router();

router.route("/api/add-product", auth, vendorAuth).post(async (req, res) => {
    try {

        const { productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images } = req.body;
        const product = new Product({ productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images });
        await product.save();

        return res.status(201).send(product);

    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
})

router.route("/api/popular-products").get(async (req, res) => {
    try {

        const product = await Product.find({ popular: true });

        if (!product || product.length == 0)
            return res.status(404).json({ msg: "products not found" });
        else
            return res.status(200).json(product);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

router.route("/api/recommended-products").get(async (req, res) => {
    try {

        const product = await Product.find({ recommend: true });

        if (!product || product.length == 0)
            return res.status(404).json({ msg: "products not found" });
        else
            return res.status(200).json({ product });

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

router.route("/api/products-by-category/:category").get(async (req, res) => {
    try {

        const { category } = req.params;

        const products = await Product.find({ category, popular: true });

        if (!products || products.length == 0)
            return res.status(404).json({ msg: "Products not found" });
        else
            return res.status(200).json(products);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

router.route("/api/related-products-by-subcategory/:productId").get(async (req, res) => {
    try {
        const { productId } = req.params;
        const product = await Product.findById(productId);
        if (!product)
            return res.status(404).json({ msg: "Product not found" });
        else {
            const relatedProducts = await Product.find({ subCategory: product.subCategory, _id: { $ne: productId } });
            if (!relatedProducts || relatedProducts.length == 0) {
                return res.status(404).json({ msg: "No related products found" });
            }
            else return res.status(200).json(relatedProducts);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

router.route("/api/top-rated-products").get(async (req, res) => {
    try {
        const topRatedProducts = await Product.find({}).sort({ averageRating: -1 }).limit(1);
        if (!topRatedProducts || topRatedProducts.length == 0) {
            return res.status(404).json({ msg: "No top-rated products found" });
        }
        else return res.status(200).json(topRatedProducts);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/products-by-subcategory/:subCategory").get(async (req, res) => {
    try {

        const { subCategory } = req.params;

        const products = await Product.find({ subCategory: subCategory });

        if (!products || products.length == 0)
            return res.status(404).json({ msg: "No Products found in this subcategory" });
        else
            return res.status(200).json(products);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/search-products").get(async (req, res) => {
    try {

        const { query } = req.query;

        if (!query)
            return res.status(404).json({ msg: "Query parameter required" });
        const products = await Product.find({ $or: [{ productName: { $regrex: query, $options: "i" } , description: { $regrex: query, $options: "i" } }] });

        if (!products || products.length == 0)
            return res.status(404).json({ msg: "No Products found matching the query" });
        else
            return res.status(200).json(products);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/edit-product/:productId",auth,vendorAuth).put(async(req,res)=>{
    try {
        const { productId } = req.params;
        const product = await Product.findById(productId);
        if (!product){
            return res.status(404).json({ msg: "Product not found" });
        }

        if(product.vendorId.toString() != req.user.id){
            return res.status(403).json({msg: "Unauthorized to edit this product"});
        }

        const {vendorId, ...updateData} = req.body;

        const updateProduct = await Product.findByIdAndUpdate(
            productId, 
            {$set: updateData}, 
            {new: true},
        );

        return res.status(200).json(updateProduct);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


module.exports = router;