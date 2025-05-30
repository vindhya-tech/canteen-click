const MenuItem = require('../models/MenuItem');

exports.getMenuItems = async (req, res) => {
  const items = await MenuItem.find();
  res.json(items);
};

exports.addMenuItem = async (req, res) => {
  const { name, price } = req.body;
  const newItem = new MenuItem({ name, price });
  await newItem.save();
  res.status(201).json(newItem);
};

exports.updateAvailability = async (req, res) => {
  const { id } = req.params;
  const { isAvailable } = req.body;
  const item = await MenuItem.findByIdAndUpdate(id, { isAvailable }, { new: true });
  res.json(item);
};
