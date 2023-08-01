const express = require('express');
const app = express()
const port = process.env.PORT || 8000

// Connecting to server
require("./database/mongoose")


app.get("/",(req,res)=>{
    res.send("Welcome to IIITDM Kancheepuram")
})

app.get("/user",(req,res)=>{
    res.send("User route")
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
  