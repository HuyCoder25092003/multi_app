const express = require("express");
const Banner = require("../models/banner");

var router = express.Router();

router.route("/api/banner").post(async(req, res)=>{
    try {
        
        const {image} = req.body;
        const banner = new Banner({image});
        await banner.save();

        return res.status(201).send(banner);

    } catch (error) {
        return res.status(500).json({error:e.message});
    }
}).get(async(req,res)=>{
    try {
        
        const banners = await Banner.find();
        
        return res.status(200).send(banners);
    
    } catch (e) {
        return res.status(500).json({error:e.message});
    }
})

module.exports = router;