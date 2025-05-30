const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Static assets (if any)
app.use('/images', express.static(path.join(__dirname, 'assets/images')));

// Routes
const authRoutes = require('./routes/auth');          // Auth route
const menuRoutes = require('./routes/menuRoutes');    // Menu route
const orderRoutes = require('./routes/orders');       // Orders route

app.use('/api/auth', authRoutes);     // Login & signup
app.use('/api/menu', menuRoutes);     // Menu operations
app.use('/api/orders', orderRoutes);  // Order operations

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log(' MongoDB connected');
    app.listen(5000, '0.0.0.0', () => {
      console.log(' Server running at http://localhost:5000');
    });
  })
  .catch((err) => {
    console.error(' MongoDB connection error:', err);
  });