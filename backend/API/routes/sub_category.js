const express = require("express");
const SubCategory = require("../models/sub_category");

var router = express.Router();

router.route("/api/subcategories").post(async(req, res)=>{
    try {
        
        const { categoryId, categoryName,  image, subCategoryName } = req.body;
        const subCategory = new SubCategory({categoryId, categoryName, image, subCategoryName});
        await subCategory.save();

        return res.status(201).send(subCategory);

    } catch (error) {
        return res.status(500).json({error:e.message});
    }
}).get(async(req,res)=>{
    try {
        
        const subcategories = await SubCategory.find();
        
        return res.status(200).json(subcategories);
    
    } catch (e) {
        res.status(500).json({error:e.message});
    }
})

router.route("/api/category/:categoryName/subcategories").get(async(req,res)=>{
    try {
        
        const {categoryName} = req.params;

        const subCategories = await SubCategory.find({categoryName: categoryName});
        
        if(!subCategories || subCategories.length == 0)
            return res.status(404).json({msg: "subCategories not found"});
        else
            return res.status(200).json(subCategories);
    
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

module.exports = router;