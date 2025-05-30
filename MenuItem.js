const mongoose = require('mongoose');

const menuItemSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
  isAvailable: { type: Boolean, default: true },
  imageUrl: { type: String, default: '' } 
});

module.exports = mongoose.model('MenuItem', menuItemSchema);
