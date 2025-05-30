const Order = require('../models/Order');

const placeOrder = async (req, res) => {
  try {
    // Get last order to find the latest orderId
    const lastOrder = await Order.findOne().sort({ orderId: -1 });
    const newOrderId = lastOrder ? lastOrder.orderId + 1 : 1;

    const newOrder = new Order({
      orderId: newOrderId,
      items: req.body.items,
      totalAmount: req.body.totalAmount,
      upiId: req.body.upiId,
    });

    await newOrder.save();
    res.status(201).json({ message: 'Order placed successfully', order: newOrder });
  } catch (err) {
    console.error('Error placing order:', err);
    res.status(500).json({ error: 'Failed to place order' });
  }
};

module.exports = { placeOrder };
