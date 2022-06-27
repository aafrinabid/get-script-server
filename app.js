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



// async function hashPassword(p){
//     const password=await bcrypt.hash(p,10);
//     return password;
// }

// const compPassword=async(p)=>{
//     const p
// }


app.post('/registerProducer',async(req,res)=>{
    try{
        const {username,password,email,firstName,lastName}=req.body;
        console.log(password,username)
        const user=await pool.query('SELECT * FROM producers WHERE username=$1',[username]);
        const useremail= await pool.query('SELECT * FROM producers WHERE email=$1',[email])
        console.log(user)
        if(user.rowCount>0){
           throw new Error('Person with this username already exist') 
        }
        if(useremail.rowCount>0){
            throw new Error('person with this email already exist')
        }
        else{
            const salt =await bcrypt.genSalt(10);
            console.log(salt)
         const hashPassword=await bcrypt.hash(password,salt);
         console.log(hashPassword)
         const NewUser=await pool.query('INSERT INTO producers(username,email,firstname,lastname,password,status,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'pending',false]);
         res.status(200).json({auth:true,role:2,status:'pending'})
       }
    }catch(err){
    res.status(400).json({message:err.message,auth:false })
    }
}
)

app.post('/loginProduer',async(req,res)=>{
    try{
        const {username,password}=req.body
        const user= await pool.query('SELECT * FROM producers WHERE username=$1',[username])
        if(user.rowCount===1){
            const compPass= await bcrypt.compare(password,user.rows[0].password)
            if(compPass){
                const id=user.rows[0].producer_id
                const status=user.rows[0].status
                const token= jwt.sign({id},'jwtsecret',{
                    expiresIn:3000,
                })
                if(user.rows[0].status==='pending'){
                    throw new Error('Awaiting confirmation from the presidernt')
                }
                if(user.rows[0].status==='approved'){
                const result=user.rows[0];
                res.status(200).json({result,token:token,status,auth:true,role:2})
                }
            }else{
                throw new Error('Password is Wrong')
            }
        }
    }catch(e){
        res.status(400).json({message:e.message})
    }
})

app.post('/approved',async(req,res)=>{
    const {username}=req.body;
    await pool.query('UPDATE producers SET status=$1 WHERE username=$2',['approved',username])

})

app.post('/reject',async(req,res)=>{
const {username}=req.body;
await pool.query('UPDATE producers SET is_deleted=$1 WHERE username=$2',[true,username])
}
)

app.listen(4000,()=>{
    console.log('listening at 4000')
})