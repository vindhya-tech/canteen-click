const express = require('express');
const moment = require('moment');
const Order = require('../models/Order');
const Counter = require('../models/Counter'); // Import the Counter model
const router = express.Router();

// Generate unique order ID based on date and MongoDB-stored counter
async function generateOrderID() {
  const today = moment().format('YYYY-MM-DD'); // Get today's date in YYYY-MM-DD format

  try {
    // Try to find and update the counter atomically
    const counter = await Counter.findOneAndUpdate(
      { date: today }, // Find by today's date
      { $inc: { count: 1 } }, // Increment the counter
      { new: true, upsert: true } // Create if not exists
    );

    // If counter is found/created, return formatted order ID
    return moment(today).format('YYYYMMDD') + '-' + counter.count; // Format: YYYYMMDD-1, YYYYMMDD-2, etc.
  } catch (err) {
    console.error('Error generating order ID:', err);
    throw new Error('Failed to generate order ID');
  }
}

// Get all orders
router.get('/', async (req, res) => {
  try {
    const orders = await Order.find();
    res.status(200).json(orders);
  } catch (err) {
    console.error('Error fetching orders:', err);
    res.status(500).json({ message: 'Failed to fetch orders' });
  }
});

// Create a new order
// router.post('/', async (req, res) => {
//   const { items, totalAmount, status = 'active', timestamp } = req.body;

//   // Check if essential fields are present
//   if (!items || !totalAmount || !timestamp) {
//     console.log('Missing required fields:', { items, totalAmount, timestamp });
//     return res.status(400).json({ message: 'Missing required fields' });
//   }

//   try {
//     // Generate unique order ID
//     const orderID = await generateOrderID();
//     console.log('Generated Order ID:', orderID);

//     const newOrder = new Order({
//       orderID,        // Add the generated order ID
//       items,          // List of items in the order
//       totalAmount,    // Total order amount
//       status,         // Order status (default is "active")
//       timestamp, 
//       place     // Timestamp of the order
//     });

//     // Save the new order to the database
//     const savedOrder = await newOrder.save();
//     console.log('Order saved:', savedOrder);

//     res.status(201).json(savedOrder); // Respond with the saved order
//   } catch (err) {
//     console.error('Error creating order:', err);
//     res.status(500).json({ message: 'Failed to create order', error: err.message });
//   }
// });
router.post('/', async (req, res) => {
  const { items, totalAmount, status = 'active', timestamp, place } = req.body; // 🛠️ include place

  if (!items || !totalAmount || !timestamp || !place) {
    console.log('Missing required fields:', { items, totalAmount, timestamp, place });
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    const orderID = await generateOrderID();
    console.log('Generated Order ID:', orderID);

    const newOrder = new Order({
      orderID,
      items,
      totalAmount,
      status,
      timestamp,
      place // ✅ Now this works
    });

    const savedOrder = await newOrder.save();
    console.log('Order saved:', savedOrder);

    res.status(201).json(savedOrder);
  } catch (err) {
    console.error('Error creating order:', err);
    res.status(500).json({ message: 'Failed to create order', error: err.message });
  }
});

// Mark order as completed
router.patch('/:id/complete', async (req, res) => {
  try {
    const order = await Order.findByIdAndUpdate(
      req.params.id,
      { status: 'completed' },
      { new: true }
    );

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    res.status(200).json(order);
  } catch (err) {
    console.error('Error marking order as completed:', err);
    res.status(500).json({ message: 'Failed to mark order as completed' });
  }
});

module.exports = router; 