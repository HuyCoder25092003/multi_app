const express = require("express");
const Order = require("../models/order");
const {auth,vendorAuth} = require("../middleware/auth");

var router = express.Router();

router.route("/api/orders",auth).post(async(req, res) => {
    try {
        const {
            fullName,
            email,
            state,
            city,
            locality,
            productName,
            productPrice,
            quantity,
            category,
            image,
            buyerId,
            vendorId,
        } = req.body;

        const createdAt = new Date().getMilliseconds()

        const order = new Order({
            fullName,
            email,
            state,
            city,
            locality,
            productName,
            productPrice,
            quantity,
            category,
            image,
            buyerId,
            vendorId,
            createdAt
        });
        await order.save();
        return res.status(201).send(order);

    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
})

router.route("/api/orders/:buyerId",auth).get(async (req, res) => {
    try {

        const { buyerId } = req.params;

        const orders = await Order.find({ buyerId });

        if (!orders || orders.length == 0)
            return res.status(404).json({ msg: "Orders not found for this buyer" });
        else
            return res.status(200).json(orders);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/orders/:id",auth).delete(async (req, res) => {
    try {

        const { id } = req.params;

        const deletedOrder = await Order.findByIdAndDelete(id);

        if (!deletedOrder || deletedOrder.length == 0)
            return res.status(404).json({ msg: "Orders not found" });
        else
            return res.status(200).json({ msg: "Orders was deleted successfully" });

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/orders/vendors/:vendorId",auth,vendorAuth).get(async (req, res) => {
    try {

        const { vendorId } = req.params;

        const orders = await Order.find({ vendorId });

        if (!orders || orders.length == 0)
            return res.status(404).json({ msg: "Orders not found for this vendorId" });
        else
            return res.status(200).json(orders);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/orders/:id/delivered").patch(async (req, res) => {
    try {

        const { id } = req.params;

        const updatedOrder = await Order.findByIdAndUpdate(id, { delivered: true, processing: false }, { new: true });

        if (!updatedOrder || updatedOrder.length == 0)
            return res.status(404).json({ msg: "Orders not found" });
        else
            return res.status(200).json(updatedOrder);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/orders/:id/processing").patch(async (req, res) => {
    try {

        const { id } = req.params;

        const updatedOrder = await Order.findByIdAndUpdate(id, { processing: false, delivered: false }, { new: true });

        if (!updatedOrder || updatedOrder.length == 0)
            return res.status(404).json({ msg: "Orders not found" });
        else
            return res.status(200).json(updatedOrder);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.route("/api/orders").get(async(req,res)=>{
    try {
        const orders = await Order.find();
        res.status(200).json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = router;