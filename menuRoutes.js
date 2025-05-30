const express = require('express');
const router = express.Router();
const MenuItem = require('../models/MenuItem');

// POST: Add new menu item with image URL
router.post('/add', async (req, res) => {
  try {
    const { name, price, imageUrl, isAvailable } = req.body;

    const newItem = new MenuItem({
      name,
      price,
      imageUrl, // 🔥 Accept image URL from request body
      isAvailable: isAvailable ?? true,
    });

    await newItem.save();
    res.status(201).json(newItem);
  } catch (err) {
    console.error('Error adding item:', err);
    res.status(400).json({ error: 'Failed to add item' });
  }
});

// GET: Fetch all menu items
router.get('/', async (req, res) => {
  try {
    const items = await MenuItem.find();
    res.json(items);
  } catch (err) {
    console.error('Error fetching menu items:', err);
    res.status(500).json({ error: 'Failed to fetch menu items' });
  }
});

// PUT: Update availability status
router.put('/:id/availability', async (req, res) => {
  try {
    const { id } = req.params;
    const { isAvailable } = req.body;

    const updatedItem = await MenuItem.findByIdAndUpdate(
      id,
      { isAvailable },
      { new: true }
    );

    if (!updatedItem) {
      return res.status(404).json({ error: 'Menu item not found' });
    }

    res.status(200).json(updatedItem);
  } catch (err) {
    console.error('Error updating availability:', err);
    res.status(500).json({ error: 'Failed to update availability' });
  }
});

// DELETE: Remove a menu item by ID
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const deletedItem = await MenuItem.findByIdAndDelete(id);

    if (!deletedItem) {
      return res.status(404).json({ error: 'Menu item not found' });
    }

    res.status(200).json({ message: 'Menu item deleted successfully' });
  } catch (err) {
    console.error('Error deleting menu item:', err);
    res.status(500).json({ error: 'Failed to delete menu item' });
  }
});

module.exports = router;
