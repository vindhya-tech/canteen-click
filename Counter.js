// models/Counter.js

const mongoose = require('mongoose');

// Define a counter schema to track orders per day
const counterSchema = new mongoose.Schema({
  date: { type: String, required: true, unique: true }, // Format: YYYY-MM-DD
  count: { type: Number, default: 0 }, // Counter for that day
});

const Counter = mongoose.model('Counter', counterSchema);

module.exports = Counter;
