const express = require("express");

const jwt = require("jsonwebtoken");

const User = require("../models/user");

const bcrypt = require("bcryptjs");
const user = require("../models/user");

var router = express.Router();

router.route("/api/signup").post(async(req, res)=>{
    try {
        const {fullName, email, password} = req.body;

        const existingEmail = await User.findOne({email});

        if(existingEmail)
            return res.status(400).json({msg:"user with same email already exist"})
        else{
            //generate a salt with a cost factor of 10
            const salt = await bcrypt.genSalt(10);
            //hash the password using the generated salt
            const hashedPassword = await bcrypt.hash(password, salt);
            var user = new User({fullName, email, password:hashedPassword});
            user = await user.save();
            res.json({user});
        }        
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

router.route("/api/signin").post(async(req, res)=>{
    try {
        const {email, password} = req.body;

        const findUser = await User.findOne({email});

        if(!findUser)
            return res.status(400).json({msg: "User not found with this email"});
        else{
            const isMatch = await bcrypt.compare(password, findUser.password);
            if(!isMatch)
                return res.status(400).json({msg: "Incorrect Password"});
            else{
                const token = jwt.sign({id:findUser._id}, "passwordKey");
                const {password, ...userWithoutPassword } = findUser._doc;

                res.json({token,user:userWithoutPassword});
            }
        }
                  
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

router.route("/api/users/:id").put(async(req,res)=>{
    try {
        const {id} = req.params;
        const {state, city, locality} = req.body;
        const updateUser = await User.findByIdAndUpdate(
            id,
            {state, city, locality},
            {new:true},
        );
        if(!updateUser)
            return res.status(404).json({msg: "User not found"});
        else return res.status(200).json(updateUser);

    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

router.route("/api/users").get(async(req,res)=>{
    try {
        const users = await User.find().select("-password");
        res.status(200).json(users);
    } catch (e) {
        res.status(500).json({error:e.message});
    }
});

module.exports = router;