const express = require("express");
const Vendor = require("../models/vendor");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const vendor = require("../models/vendor");
var router = express.Router();

router.route("/api/vendor/signup").post(async (req, res) => {
    try {
        const { fullName, email, password } = req.body;

        const existingEmail = await Vendor.findOne({ email });

        if (existingEmail)
            return res.status(400).json({ msg: "vendor with same email already exist" })
        else {
            //generate a salt with a cost factor of 10
            const salt = await bcrypt.genSalt(10);
            //hash the password using the generated salt
            const hashedPassword = await bcrypt.hash(password, salt);
            let vendor = new Vendor({ fullName, email, password: hashedPassword });
            vendor = await vendor.save();
            res.json({ vendor });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/vendor/signin").post(async (req, res) => {
    try {
        const { email, password } = req.body;

        const findUser = await Vendor.findOne({ email });

        if (!findUser)
            return res.status(400).json({ msg: "Vendor not found with this email" });
        else {
            const isMatch = await bcrypt.compare(password, findUser.password);
            if (!isMatch)
                return res.status(400).json({ msg: "Incorrect Password" });
            else {
                const token = jwt.sign({ id: findUser._id }, "passwordKey");
                const { password, ...vendorWithoutPassword } = findUser._doc;

                res.json({ token, vendor: vendorWithoutPassword });
            }
        }

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/vendors").get(async(req,res)=>{
    try {
        const vendors = await Vendor.find().select("-password");
        res.status(200).json(vendors);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

module.exports = router;