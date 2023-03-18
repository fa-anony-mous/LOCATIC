const { default: mongoose } = require("mongoose");

const Pictures = new Schema({
    name: { type: String, default: 'default' },
    imgURL: { type: String},
    imgID: { type: String },
  });
  
mongoose.model(Pictures)
