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
            
         const hashPassword=await bcrypt.hash(password,10);
         console.log(hashPassword)
         const NewUser=await pool.query('INSERT INTO producers(username,email,firstname,lastname,password,status,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'pending',false]);
         const id= NewUser.rows[0].producer_id
         const token= jwt.sign({id},'jwtsecret',{
            expiresIn:3000,
        })
         res.status(200).json({token:token,auth:true,role:2,status:'pending'})
       }
    }catch(err){
    res.status(400).json({message:err.message,auth:false })
    }
}
)

app.post('/loginProducer',async(req,res)=>{
    try{
        const {username,password}=req.body
        console.log(req.body)
        const user= await pool.query('SELECT * FROM producers WHERE username=$1',[username])
        if(user.rowCount===1){
            console.log(user.rows[0].password)
            const compPass= await bcrypt.compare(password,user.rows[0].password)
            if(compPass){
                const id=user.rows[0].producer_id
                const status=user.rows[0].status
                const token= jwt.sign({id},'jwtsecret',{
                    expiresIn:3000,
                })
                if(user.rows[0].status==='pending'){
                    // throw new Error('Awaiting confirmation from the presidernt')
                    res.status(200).json({token:token,status,auth:true,role:2})
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
    try{
        const {id}=req.body;
        console.log(id)
        const result=await pool.query('UPDATE producers SET status=$1 WHERE producer_id=$2 RETURNING status',['approved',id])

        console.log(result)
        if(result.rows[0]['status']==='approved'){

            res.status(200).json({status:true})
        }
        else{
            throw new Error('some thing wrong happened')
        }
    }catch(e){
        console.log(e)
    }
   

})

app.post('/reject',async(req,res)=>{
try{const {id}=req.body;
const result=await pool.query('UPDATE producers SET is_deleted=$1,status=$2 WHERE producer_id=$3 RETURNING is_deleted,status',[true,'rejected',id])
console.log(result.rows[0])
if(result.rows[0]['is_deleted']){

    res.status(200).json({deleted:true})
}else{
    throw new Error('somenthing happend at our end sorry ')
}
}catch(e){
    console.log(e)
}
}
)

app.get('/fetchProducers',async(req,res)=>{
    try{
        const fetchedProducers=await pool.query('SELECT * FROM producers')
        const result=fetchedProducers.rows;

        res.status(200).json({result})
    }catch(e){
        res.status(400).json({message:e.message})
    }
  

})

app.listen(4000,()=>{
    console.log('listening at 4000')
})