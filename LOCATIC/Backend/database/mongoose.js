const pass = "database"
const uri = `mongodb+srv://Sram:${pass}@cluster0.syrdvcb.mongodb.net/?retryWrites=true&w=majority`

const mongoose = require('mongoose');
mongoose.connect('mongodb://127.0.0.1:27017/test')
    .then(() => console.log('Connected!'));

    