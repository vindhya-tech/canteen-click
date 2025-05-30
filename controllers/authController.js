const Student = require('../models/Student');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Student signup
const signup = async (req, res) => {
  const { rollNo, password } = req.body;

  if (!rollNo || !password || rollNo.length !== 10) {
    return res.status(400).json({ message: 'Roll No. must be exactly 10 characters.' });
  }

  const existing = await Student.findOne({ rollNo });
  if (existing) return res.status(409).json({ message: 'Roll No already exists' });

  const hashedPass = await bcrypt.hash(password, 10);
  const student = new Student({ rollNo, password: hashedPass });
  await student.save();

  res.status(201).json({ message: 'Signup successful' });
};

// Student and staff login
const login = async (req, res) => {
  const { role, id, password } = req.body;

  // Staff login (fixed ID/password)
  if (role === 'Staff') {
    if (id === 'admin123' && password === '123') {
      const token = jwt.sign({ role: 'Staff' }, process.env.JWT_SECRET);
      return res.json({ token, role: 'Staff' });
    } else {
      return res.status(401).json({ message: 'Incorrect staff credentials' });
    }
  }

  // Student login
  const student = await Student.findOne({ rollNo: id });
  if (!student || !(await bcrypt.compare(password, student.password))) {
    return res.status(401).json({ message: 'Invalid roll number or password' });
  }

  const token = jwt.sign({ rollNo: student.rollNo, role: 'Student' }, process.env.JWT_SECRET);
  res.json({ token, role: 'Student' });
};

module.exports = { signup, login };
