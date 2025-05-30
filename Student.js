const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  rollNo: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
});

const Student = mongoose.model('Student', studentSchema);
module.exports = Student;
