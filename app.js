const express=require('express');
const app=express()
const pool=require('./db');
const bcrypt=require('bcrypt');
const cors=require('cors');
const jwt=require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const session=require('express-session');


app.use(express.json())
app.use(express.urlencoded({extended:true}))
app.use(cors())

app.listen(4000,()=>{
    console.log('listening at 4000')
})