const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('./schema/User');

mongoose.connect(
  'mongodb+srv://Sram:database@Cluster0.syrdvcb.mongodb.net/test?retryWrites=true&w=majority',
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
  }
);

const app = express();
app.use(bodyParser.json());

app.post('/api/send-otp', async (req, res) => {
  const { email } = req.body;

  // Check if user exists
  const user = await User.findOne({ email });

  if (user) {
    // User already exists
    res.status(200).json({ message: 'OTP sent successfully.' });
  } else {
    // Create user with email as the user ID
    const newUser = new User({
      email,
      password: await bcrypt.hash(email, 10),
    });
    await newUser.save();
    res.status(200).json({ message: 'OTP sent successfully.' });
  }
});

app.post('/api/verify-otp', async (req, res) => {
  const { email, otp } = req.body;

  // Check if user exists
  const user = await User.findOne({ email });

  if (user && await bcrypt.compare(email, user.password)) {
    // OTP verification successful
    res.status(200).json({ message: 'OTP verification successful.' });
  } else {
    // Handle error response
    res.status(401).json({ message: 'Invalid OTP or email.' });
  }
});

app.listen(8000, () => {
  console.log('Server started on port 8000.');
});
