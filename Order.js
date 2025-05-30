// // models/Order.js

const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  orderID: { type: String, required: true, unique: true }, // Unique order ID
  items: [
    {
      name: { type: String, required: true },
      price: { type: Number, required: true },
      quantity: { type: Number, required: true },
    }
  ],
  totalAmount: { type: Number, required: true },
  status: { type: String, required: true, default: 'active' }, // Order status (active, completed, etc.)
  timestamp: { type: String, required: true }, // Date and time the order was placed
  // Node.js order schema (example)
  place: { type: String, required: true },
   
});

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;
// const mongoose = require('mongoose');

// const orderSchema = new mongoose.Schema({
//   orderID: { type: String, required: true, unique: true }, // Unique order ID
//   studentId: { type: String, required: true }, // NEW: Student who placed the order

//   items: [
//     {
//       name: { type: String, required: true },
//       price: { type: Number, required: true },
//       quantity: { type: Number, required: true },
//     }
//   ],

//   totalAmount: { type: Number, required: true },
//   status: { type: String, required: true, default: 'active' }, // Order status (active, completed, etc.)
//   timestamp: { type: String, required: true }, // Date and time the order was placed
//   place: { type: String, required: true },
// });

// const Order = mongoose.model('Order', orderSchema);

// module.exports = Order;
