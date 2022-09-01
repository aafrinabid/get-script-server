require('dotenv').config()
const formidable=require('formidable')
const bodyParser=require('body-parser')
const express=require('express');
const AWS= require('aws-sdk');
const app=express()
const {v4:uuidv4}=require('uuid')
const pool=require('./db');
const bcrypt=require('bcrypt');
const cors=require('cors');
const jwt=require('jsonwebtoken');
const multer=require('multer');
const mongoose=require('mongoose');
const messageModel = require('./model/messageModel');
const socket=require('socket.io');
const PaytmChecksum=require('./PaytmChecksum')
const https=require('https');
const { json } = require('express');
const stripe= require('stripe')(process.env.stripe_secret_key)
const sentEmail= require('./utils/sendEmail')
const morgan=require('morgan');
const { type } = require('os');
app.use(cors())
app.use(morgan(':method :url  STATUS: :status  RESPONSE-TIME: :response-time ms'))
const verifyJwt=(req,res,next)=>{
    const token=req.headers["x-access-token"];

    if(!token){
        console.log('no token present')
        res.send('no token is there')
    }else{
        jwt.verify(token,"jwtsecret",(err,decoded)=>{
            if(err){
                console.log('error not verified')
                return res.json({auth:false,message:'authorization failed'})
            }else{
                console.log('success verification');
                req.userId=decoded.id;
                req.role=decoded.role
               console.log(decoded)
                console.log(req.userId,'all set indeed')
                next();
            }
        })
    }

}

// const { request } = require('http');
//paytm payment
app.get('/isAuthPayment',verifyJwt,async(req,res)=>{
    const userId=req.userId
    console.log(req.headers)
    const scriptId=req.headers["scriptid"];
    console.log(userId,scriptId,'checking the body')
    const script =await pool.query('select * from script where script_id=$1 and scriptwriter_id=$2',[scriptId,userId])
    console.log(script,'checking the scriptssss')
    if(script.rowCount>0){
        res.json({pAuth:true,auth:true})
    }else{
        res.json({pAuth:false,auth:true})
    }

})
app.post('/payment',express.json(),(req,res)=>{

    const {amount,email,scriptId}=req.body
    console.log(req.body)
    const totalAmount=JSON.stringify(amount)
    /* import checksum generation utility */

var params = {};

/* initialize an array */
params["MID"] = process.env.Merchant_ID,
params["ORDER_ID"] =scriptId,
params["CHANNEL_ID"]=process.env.Channel_ID,
params["WEBSITE"]=process.env.Website,
params["INDUSTRY_TYPE_ID"]=process.env.Industry_Type,
params["CUST_ID"]=process.env.Cust_Id,
params["TXN_AMOUNT"]=totalAmount,
params["CALLBACK_URL"]='http://localhost:3500/payment/callback',
params['MOBILE_NO']='807551056',
params["EMAIL"]=email
console.log(params)


/**
* Generate checksum by parameters we have
* Find your Merchant Key in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys 
*/
var paytmChecksum = PaytmChecksum.generateSignature(params,process.env.Merchant_Key);
paytmChecksum.then(function(checksum){
    let paytmParams={
        ...params,
        "CHECKSUMHASH":checksum
    }
    res.json(paytmParams)
}).catch(function(error){
	console.log(error);
});
})

app.post('/payment/callback',(req,res)=>{

    const form=new formidable.IncomingForm();
    
    form.parse(req,(err,fields,file)=>
    {
        
    
    
    
    
    
    
    
    
    paytmChecksum =fields.CHECKSUMHASH;
    delete fields.CHECKSUMHASH;
    
    var isVerifySignature = PaytmChecksum.verifySignature(fields, process.env.Merchant_Key, paytmChecksum);
    if (isVerifySignature) {
        console.log(fields)
    
    
    
    
    
    
    
    
        var paytmParams = {};
        paytmParams["MID"]     = fields.MID;
        paytmParams["ORDER_ID"] = fields.ORDERID;
        
        /*
        * Generate checksum by parameters we have
        * Find your Merchant Key in your Paytm Dashboard at https://dashboard.paytm.com/next/apikeys 
        */
        PaytmChecksum.generateSignature(paytmParams, process.env.Merchant_Key).then(function(checksum){
        
            paytmParams["CHECKSUMHASH"] = checksum;
        
            var post_data = JSON.stringify(paytmParams);
        
            var options = {
        
                /* for Staging */
                hostname: 'securegw-stage.paytm.in',
        
                /* for Production */
                // hostname: 'securegw.paytm.in',
        
                port: 443,
                path: '/order/status',
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': post_data.length
                }
            };
        
            var response = "";
            var post_req = https.request(options, function(post_res) {
                post_res.on('data', function (chunk) {
                    response += chunk;
                });
        
                post_res.on('end', async function(){
                             let result=JSON.parse(response)
                            if(result.STATUS==='TXN_SUCCESS')
                            {
                                const update=await pool.query('UPDATE script set featured=$1 where script_id=$2',[true,result['ORDERID']])
                                const method=await pool.query('INSERT INTO payment(script_id,method) values($1,$2)',[result['ORDERID'],'paytm'])


                                console.log(result)
                                const inster=await pool.query('INSERT INTO paytm(txnid,banktxnid,orderid,txnamount,status,txntype,gatewayname,respcode,respmsg,bankname,mid,paymentmode,refundamt,txndate) values($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14)',[result['TXNID'],result['BANKTXNID'],result['ORDERID'],result['txnamount'],result['STATUS'],['TXNTYPE'],result['GATEWAYNAME'],result['RESPCODE'],result['RESPMSG'],result['BANKNAME'],result['MID'],result['PAYMENTMODE'],result['REFUNDAMT'],result['TXNDATE']])

                                // const transfer=Object.keys(result)
                                // let count=0
                                // transfer.forEach(async(list)=>{
                                //     console.log(list)
                                //     if(count===0){
                                //         console.log(list[count],result[transfer[count]],'insterting')
                                //         const insert=await pool.query('INSERT INTO paytm($1) values($2)',[list[count].toLocaleLowerCase(),result[transfer[count]]])
                                //         count++
                                //     }else{
                                //      const insert=await pool.query('UPDATE paytm set $1=$2 where ',[list[count].toLocaleLowerCase(),result[transfer[count]]])
                                //      count++
                                //     }
                                // })
                                

                                // const insert=await res


                                res.redirect('http://localhost:3000/Browse/0')
                                //store in db
                            //     db.collection('payments').doc('mPDd5z0pNiInbSIIotfj').update({paymentHistory:firebase.firestore.FieldValue.arrayUnion(result)})
                            //     .then(()=>console.log("Update success"))
                            //     .catch(()=>console.log("Unable to update"))
                            // }
    
                            // res.redirect(`http://localhost:3000/status/${result.ORDERID}`)
    
                            }
                            else{
                                res.redirect('http://localhost:3000/Browse/0')
                            }
                });
            });
        
            post_req.write(post_data);
            post_req.end();
        });        
        form.on('error', function(err) { console.log(err); });
    
    
    
    
    
    
    
    
    
    } else {
        console.log("Checksum Mismatched");
    }
    
    
    
    
    
    
    })
    
    })

// stripe payment
const generate_payment_response = (intent) => {
    if (
      intent.status === 'requires_action' &&
      intent.next_action.type === 'use_stripe_sdk'
    ) {
      // Tell the client to handle the action
      return {
        requires_action: true,
        payment_intent_client_secret: intent.client_secret
      };
    } else if (intent.status === 'succeeded') {
      // The payment didn’t need any additional actions and completed!
      // Handle post-payment fulfillment
      return {
        success: true
      };
    } else {
      // Invalid status
      return {
        error: 'Invalid PaymentIntent status'
      }
    }
  };
app.post('/paymentstripe',express.json(),express.urlencoded({extended:true}),async(req,res)=>{
    try{
        const {product,token}=req.body;
        console.log('token',token,'product',product)
        const idempotencyKey=uuidv4()
        console.log(idempotencyKey)
     const customers=await stripe.customers.create({
            email:token.email,
            source:token.id
    
        })

        const paymentMethods = await stripe.paymentMethods.list({
            customer: customers.id,
            type: 'card',
          });
          console.log(paymentMethods.data[0].id,'wheres it ******************************')
        const paymentIntent= await stripe.paymentIntents.create({
                amount:product.price*100,
                currency:'inr',
                customer:customers.id,
                receipt_email:token.email,
                payment_method:paymentMethods.data[0].id,
                confirm:true,
                metadata:{
                    orderId:product.id
                }

                // orderId:product.id,
            },{idempotencyKey})
            console.log(paymentIntent.client_secret)
            
            // const secretKey=paymentIntent.client_secret
            const data=generate_payment_response(paymentIntent)

            res.json(data)
            // res.json({clientSecret:secretKey})
            // res.status(200).json(paymentIntent)
            // res.redirect('http://localhost:3000/')
    
    }catch(e){
        console.log(e)
    }
    
    
//     .then(customer=>{
//         stripe.paymentIntents.create({
//             amount:product.price * 100,
//             currency:'inr',
//             customer:customer.id,
//             receipt_email:token.email,
//             // orderId:product.id,
//         },{idempotencyKey})
//     })
//     .then(result=>{
//         console.log(result,'resukts comming')
//         res.status(200).json(result)
//     })
//     .catch(err=>console.log(err))
})



app.post('/testStripe',async(req,res)=>{
    try{
        const paymentIntent= await stripe.paymentIntents.create({
            amount:500,
            currency:'inr',
            // orderId:product.id,
        })
        res.json({clientSecret:paymentIntent})
    }catch(e){

    }
})

app.post('/webhook',
bodyParser.raw({type:'application/json'}),
async(req,res)=>{
    try{
        const payload=req.body;
        const sig=req.headers['stripe-signature'];
        const endpointSecret='whsec_a1b22dad73cedba7b9b83e87f12b3c3a7455e6ce97e1394e8260bf23eb85565a'
    
        let event
        try{
            event=stripe.webhooks.constructEvent(payload,sig,endpointSecret)
        }catch(error){
            console.log(error)
        res.json({success:false})
    
        }
        console.log(event.type,'type')
        if(event.type==='payment_intent.succeeded'){
            console.log(event.data.object.id,'hmmmmmmmmmmmmmmmmmmmmmm')
            const data=event.data.object
            const orderId=data.metadata.orderId
            const update=await pool.query('UPDATE script set featured=$1 where script_id=$2',[true,orderId])
            const method=await pool.query('INSERT INTO payment(script_id,method) values($1,$2)',[orderId,'stripe'])
            const stripeInsert=await pool.query('INSERT INTO stripe (orderid,payment_intent_id,client_secret_key,email,customer_id,currency,amount,status,payment_method) values($1,$2,$3,$4,$5,$6,$7,$8,$9)',
            [orderId,data.id,data.client_secret,data.receipt_email,data.customer,data.currency,data.amount/100,data.status,data.payment_method]
            )
    
        }
        if(event.type==='charge.succeeded'){
            const data=event.data.object
            // console.log(data)
            const orderId=data.metadata.orderId
            console.log(event.data.object.payment_intent,'testing')
            const stripeUpdate=await pool.query('INSERT INTO stripe_charges (orderid,charge_id,paid,txnid,receipt_url) VALUES ($1,$2,$3,$4,$5)',
            [orderId,data.id,data.paid,data.balance_transaction,data.receipt_url])
            
            console.log(stripeUpdate)
            
            
            
            console.log('hurrrrrrraghhhhhhhh')
    
        }
        // console.log(event,'whats this')
        // console.log(event.data.object.id)
    
        res.json({success:true})
    
    }catch(e){
console.log(e)
    }
    
}
)

app.use(express.json())
app.use(express.urlencoded({extended:true}))

// const corsOptions ={
//     origin:'*', 
//     credentials:true,            //access-control-allow-credentials:true
//     optionSuccessStatus:200,
//  }
mongoose.connect(process.env.MONGO_URL,{
    useNewUrlParser:true,
    useUnifiedTopology:true,
}).then(()=>{
    console.log('connected with mongodatabase')
});

const s3 =new AWS.S3({
    accessKeyId:process.env.ACCESS_KEY_ID,
    secretAccessKey:process.env.SECRET_ACCESS_KEY

})

const upload=multer({
    storage:multer.memoryStorage(),
    limits:{fileSize:52428800},
})






// async function hashPassword(p){
//     const password=await bcrypt.hash(p,10);
//     return password;
// }

// const compPassword=async(p)=>{
//     const p
// }


app.get('/getId',verifyJwt,(req,res)=>{

    const userId= req.userId
const role=req.role
console.log(userId,role)
res.json({userId,role})
})

app.post('/getUsername',async(req,res)=>{
    try{
        const id=req.body.id
        console.log(req.body)
        console.log(id,'checking')
        // const username=await pool.query('select * from users where id=$1,'[id])
        const username= await pool.query('select username from users where id=$1',[id])
        console.log(username,'fetched the username you are looking for')
        res.json({username:username.rows[0].username})
    }catch(e){
        console.log(e)
    }
    

})


app.get('/isAuth',verifyJwt,async(req,res,next)=>{
    try{console.log(process.env.BUCKET_STORAGE_URL)
        const token=req.headers['x-access-token'];
    const id=req.userId
    const role=req.role
    console.log(id,role);
   let status
    if(role===1){
    console.log('user is script type');
    console.log('sfjkskf')


           const result=await pool.query('SELECT * FROM users WHERE id=$1',[id])
           console.log(result.rows)
           status=result.rows[0]['status']
           console.log(status,'coool')
           if(status==='approved'){

            res.json({auth:true,message:'you are authenticated',id,token,role,status})
        }else({auth:false,message:'not authorised yet',role,status})

    }
    if(role===2){
    console.log('user is script producer');
    const result=await pool.query('SELECT * FROM users WHERE id=$1',[id])
    console.log(result.rows)
    status=result.rows[0]['status']
    console.log('sfjkskf')
    if(status==='approved'){

        res.json({auth:true,message:'you are authenticated',id,token,role,status})
    }else({auth:false,message:'not authorised yet',role,status})

   }
   if(role===3){
    console.log('user is admin');
    console.log('sfjkskf')


           const result=await pool.query('SELECT * FROM users WHERE id=$1',[id])
           console.log(result.rows)
           status='approved'
           console.log(status,'coool')
           if(status==='approved'){

            res.json({auth:true,message:'you are authenticated',id,token,role,status})
        }else({auth:false,message:'not authorised yet',role,status})

    }
//    console.log(result)

    }catch(e){
        console.log('umborse');
    }
})

app.post('/Oauth/google',async(req,res)=>{
    try{
     const details=req.body.userObject
     const scriptWriter=req.body.scriptwriter
     console.log(details,scriptWriter)
     if(scriptWriter){
         const user=await pool.query('select * from users where email=$1',[details.email])
         if(user.rowCount>0 && user.rows[0].type==='scriptwriter'){
             const role=1
             const id=user.rows[0].id
             const token= jwt.sign({id,role},'jwtsecret',{
                 expiresIn:3000,
             })
             console.log('loging in the user scriptwrtier')
 
            return res.json({auth:true,token,status:user.rows[0].status,role})
         }
            if(user.rowCount>0 && user.rows[0].type!=='scriptwriter'){
             console.log('heeeeeeesh')
             // return new Error('You are already registered as screenwriter, please use other mail address')
             return res.json({message:'You are already registered as producer, please use other mail address',auth:false})
 
         }
         else{
             const user=await pool.query('insert into users(username,email,status,firstname,lastname,is_deleted,type,email_verified) values($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *',
             [details.email,details.email,'approved',details.given_name,details.family_name,false,'scriptwriter',true])
 
             const id=user.rows[0].id
             const role=1
             const token= jwt.sign({id,role},'jwtsecret',{
                 expiresIn:3000,
             })
             res.json({auth:true,token,status:'approved',role})
 
         }
     }else{
         const user=await pool.query('select * from users where email=$1',[details.email])
         if(user.rowCount>0 && user.rows[0].type==='producer' && user.rows[0].status==='approved'){
             const role=2
             const id=user.rows[0].id
             const token=jwt.sign({id,role},'jwtsecret',{
                 expiresIn:3000,
             })
 
             return res.json({auth:true,token,status:user.rows[0].status,role})
         }
         if(user.rows[0].type!=='producer'){
             console.log('heeeeeeesh')
             // return new Error('You are already registered as screenwriter, please use other mail address')
             return res.json({message:'You are already registered as screenwriter, please use other mail address',auth:false})
 
         }
         else{
             const user=await pool.query('insert into users(username,email,status,firstname,lastname,is_deleted,type,email_verified) values($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *',
             [details.email,details.email,'pending',details.given_name,details.family_name,false,'producer',true])
 
             const id=user.rows[0].id
             const role=2
             const token= jwt.sign({id,role},'jwtsecret',{
                 expiresIn:3000,
             })
             res.json({auth:true,token,status:'pending',role})
 
         }
      
     }
    }catch(e){
     console.log(e)
 
     res.json({message:e.message,auth:false})
    }
     
 })
//producer


app.post('/registerProducer',async(req,res)=>{
    try{
        const {username,password,email,firstName,lastName}=req.body;
        console.log(password,username)
        // if(username='aafrin'){
        //     console.log('not happening in usernaem')
        //     res.status(400).json({auth:false,message:'username already exist'})
        // }
        const user=await pool.query('SELECT * FROM users WHERE username=$1',[username]);
        const useremail= await pool.query('SELECT * FROM users WHERE email=$1',[email])
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
         const NewUser=await pool.query('INSERT INTO users(username,email,firstname,lastname,password,status,is_deleted,TYPE,email_verified) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'pending',false,'producer',false]);
         const id= NewUser.rows[0].id
         const role=2
         const userEmail=NewUser.rows[0].email
         console.log(process.env.Node_mailer_Pass)
         const verification=await pool.query('INSERT INTO email_verification(users_id) VALUES($1) RETURNING *',[id])
         const emailToken =verification.rows[0].token
         const url=`http://localhost:3500/${id}/verify/${emailToken}`
         await sentEmail(userEmail,'verify email',url,process.env.Node_mailer_Pass)          
         const token= jwt.sign({id,role},'jwtsecret',{
            expiresIn:3000,
        })
         res.status(200).json({token:token,auth:true,role,status:'pending'})
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
        const user= await pool.query('SELECT * FROM users WHERE username=$1 AND TYPE=$2',[username,'producer'])
        if(user.rowCount===1){
            console.log(user.rows[0].password)
            const compPass= await bcrypt.compare(password,user.rows[0].password)
            if(compPass){
                const id=user.rows[0].id
                const role=2
                const status=user.rows[0].status
                const token= jwt.sign({id,role},'jwtsecret',{
                    expiresIn:3000,
                })
                if(user.rows[0].status==='pending'){
                    // throw new Error('Awaiting confirmation from the presidernt')
                    res.status(200).json({token:token,status,auth:true,role})
                }
                if(user.rows[0].status==='approved'){
                const result=user.rows[0];
                res.status(200).json({result,token:token,status,auth:true,role})
                }
            }else{
                throw new Error('Password is Wrong')
            }
        }
    }catch(e){
        res.status(400).json({message:e.message})
    }
})


//scriptwriter
app.post('/registerScriptwriter',async(req,res)=>{
    try{
        const {username,password,email,firstName,lastName}=req.body;
        console.log(password,username)
        const user=await pool.query('SELECT * FROM users WHERE username=$1 AND TYPE=$2',[username,'scriptwriter']);
        const useremail= await pool.query('SELECT * FROM users WHERE email=$1 AND TYPE=$2',[email,'scriptwriter'])
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
         const NewUser=await pool.query('INSERT INTO users(username,email,firstname,lastname,password,status,is_deleted,TYPE,email_verified) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'approved',false,'scriptwriter',false]);
         const id= NewUser.rows[0].id
         const role=1
         const userEmail=NewUser.rows[0].email
         console.log(process.env.Node_mailer_Pass)
         const verification=await pool.query('INSERT INTO email_verification(users_id) VALUES($1) RETURNING *',[id])
         const emailToken =verification.rows[0].token
         const url=`http://localhost:3500/${id}/verify/${emailToken}`
         await sentEmail(userEmail,'verify email',url,process.env.Node_mailer_Pass)          
         const token= jwt.sign({id,role},'jwtsecret',{
            expiresIn:3000,
        })
         res.status(200).json({token:token,auth:true,role,status:'approved'})
       }
    }catch(err){
    res.status(400).json({message:err.message,auth:false })
    }
})

app.post('/loginScriptwriter',async(req,res)=>{
    try{
        const {username,password}=req.body
        console.log(req.body)
        const user= await pool.query('SELECT * FROM users WHERE username=$1 AND TYPE=$2',[username,'scriptwriter'])
        if(user.rowCount===1){
            console.log(user.rows[0].password)
            const compPass= await bcrypt.compare(password,user.rows[0].password)
            if(compPass){
                const id=user.rows[0].id
                const status=user.rows[0].status
                const role=1
                const token= jwt.sign({id,role},'jwtsecret',{
                    expiresIn:3000,
                })
                if(user.rows[0].status==='blocked'){
                    // throw new Error('Awaiting confirmation from the presidernt')
                    res.status(200).json({token:token,status,auth:false,role})
                }
                if(user.rows[0].status==='approved'){
                const result=user.rows[0];
                res.status(200).json({result,token:token,status,auth:true,role})
                }
            }else{
                throw new Error('Password is Wrong')
            }
        }else{
            throw new Error('user does not exist')
        }
    }catch(e){
        console.log(e.message)
        res.status(400).json({message:e.message,auth:false})
    }
})

app.get('/:id/verify/:token',async(req,res)=>{
    try{
        const id=req.params.id
        const token=req.params.token
        console.log(id,token,'checcccccking')
        const user= await pool.query('select * from email_verification where users_id=$1 and token=$2',[id,token])
        console.log(user.rows[0])
        if(user.rowCount>0){
            console.log(user.rows[0])
            const update=await pool.query('update users set email_verified=$1 where id=$2',[true,id])
             return res.redirect('http://localhost:3000/')
        }else{
        return res.send('INVALID URL')
        }

    }
    catch(e){
    console.log(e)
    }
})

//adminpanel
app.post('/approved',async(req,res)=>{
    try{
        const {id}=req.body;
        console.log(id)
        const result=await pool.query('UPDATE users SET status=$1 WHERE id=$2 RETURNING status',['approved',id])

        console.log(result)
        if(result.rows[0]['status']==='approved'){

            res.status(200).json({status:true,id:id})
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
const result=await pool.query('UPDATE users SET is_deleted=$1,status=$2 WHERE id=$3 RETURNING is_deleted,status',[true,'rejected',id])
console.log(result.rows[0])
if(result.rows[0]['is_deleted']){

    res.status(200).json({deleted:true,id})
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
        const fetchedProducers=await pool.query('SELECT * FROM users WHERE is_deleted=$1 AND TYPE=$2' ,[false,'producer'])
        const result=fetchedProducers.rows;
        console.log(result)

        res.status(200).json({result})
    }catch(e){
        res.status(400).json({message:e.message})
    }
  

})

app.get('/getUserCount',async(req,res)=>{
    try{
        const producers=await pool.query('SELECT COUNT(id) FROM users WHERE status=$1 AND type=$2',['approved','producer'])
        const pendingProducers=await pool.query('SELECT COUNT(id) FROM users WHERE status=$1 AND type=$2 ',['pending','producer'])
        const declinedProducers=await pool.query('SELECT COUNT(id) FROM users WHERE status=$1 type=$2',['rejected','producer'])
        const producerCount=parseInt(producers.rows[0].count) 
        const pendingProducersCount=parseInt(pendingProducers.rows[0].count)
        const declinedProducersCount=parseInt(declinedProducers.rows[0].count)

        const scriptwriters=await pool.query('SELECT COUNT(id) FROM users WHERE status=$1 type=$2',['approved','scriptwriter'])
        const declinedScriptwriters=await pool.query('SELECT COUNT(id) FROM users WHERE status=$1 type=$2',['rejected','scriptwriter'])
        const scriptwriterCount=parseInt(scriptwriters.rows[0].count)
        const declinedScriptwritersCount=parseInt(declinedScriptwriters.rows[0].count)

        const totalUsers=scriptwriterCount+producerCount
        const blockedUsers=declinedProducersCount+declinedScriptwritersCount;
        res.status(200).json({scriptwriterCount,producerCount,totalUsers,pendingProducersCount,declinedProducersCount,declinedScriptwritersCount,blockedUsers})


    }catch(e){
        console.error(e)
        res.json({message:e})

    }
})

app.post('/adminlogin',async(req,res)=>{
    try{
        const {username,password}=req.body;
        const admin=await pool.query('SELECT * FROM users WHERE username=$1',[username])
        if(admin.rowCount===1){
            if(admin.rows[0]['password']===password){
                console.log(admin.rows[0])
                const role=3;
                const id=admin.rows[0]['id']
                const token= jwt.sign({id,role},'jwtsecret',{
                    expiresIn:3000,
                })
                const status='approved'
    
                res.status(200).json({token,status,auth:true,role})
            }else{
                console.log('booooooo')
                res.status(400).json({message:'username already exist choose another one',auth:false})
            }
        }
    }catch(e){
        res.status(400).json({e,auth:false,})
    }
    
})

app.get('/fetchnotification',async(req,res)=>{
    const pendingRequests=await pool.query('SELECT * FROM users WHERE status=$1 AND TYPE=$2',['pending','producer'])
    if(pendingRequests.rowCount>0){
        const result=pendingRequests.rows

        res.status(200).json({result})
    }
})

//script


app.post('/uploadscript',upload.single('file'),async(req,res)=>{
    try{
        const type=req.file.mimetype
        console.log(type)
        let ext
        console.log(type.endsWith('png'))
        type.endsWith('png')?ext='png':type.endsWith('pdf')?ext='pdf':type.endsWith('jpg')?ext='jpg':type.endsWith('jpeg')?ext='jpeg':''
        console.log(ext)
        const filename=Date.now().toString()
        s3.putObject({
            Bucket:process.env.BUCKET_NAME,
            Key:`${filename}.${ext}`,
            Body:req.file.buffer,
            ACL:'public-read',   
        },(err)=>{
            if(err)return res.status(400).send(err)
            console.log(`${process.env.BUCKET_STORAGE_URL}${filename}.${ext}`)
            const url=`${process.env.BUCKET_STORAGE_URL}${filename}.${ext}`
            res.json({message:'File uploaded to S3;',url})
        })

    }catch(e){
        console.log(e)
    }
   
    
})
const typeHandler=(type,name)=>{
    console.log('in type')
if(name==='entertainment'){
    if(type===10){
        return 'MOVIE'
    }
    if(type===20){
        return 'TV_Series'
    }
    if(type===30){
        return 'Anime'
    }

}
if(name==='script'){
    if(type===10){
        return 'Movie Concept'
    }
    if(type===20){
        return 'Series Pilot Episode'
    }
    if(type===30){
        return 'Series Concept'
    }
    if(type===40){
        return 'Anime Concept'
    }
    if(type===50){
        return 'Short Film Concept'
    }
}
    
}

const nextTypeHandler=(type,name)=>{
    console.log('in type')
if(name==='entertainment'){
    if(type==='MOVIE'){
        return 10
    }
    if(type==='TV_Series'){
        return 20
    }
    if(type==='Anime'){
        return 30
    }

}
if(name==='script'){
    if(type==='Movie Concept'){
        return 10
    }
    if(type==='Series Pilot Episode'){
        return 20
    }
    if(type==='Series Concept'){
        return 30
    }
    if(type==='Anime Concept'){
        return 40
    }
    if(type==='Short Film Concept'){
        return 50
    }
}
    
}



app.post('/nextScriptEpisode',async(req,res)=>{
    try{
        const {id}=req.body
        const script= await pool.query('SELECT * from script where script_id=$1 AND main=$2',[id,true])
        let mainScript
        if(script.rowCount>0){
 mainScript=script.rows[0].script_id
        }else{
            const script= await pool.query('SELECT * from series_episodes where child_script=$1',[id])
            mainScript=script.rows[0].main_script
        }

        const scriptDetail= await pool.query('select script.featured,users.id,script_details.*,script_pitch_table.* from script join users on script.scriptwriter_id = users.id join script_details on script.script_id= script_details.script_id  join script_pitch_table on script.script_id=script_pitch_table.script_id WHERE script.script_id=$1',[mainScript])
        const result={
            titleName : scriptDetail.rows[0].script_title,
           entertainmentType:nextTypeHandler(scriptDetail.rows[0].entertainment,'entertainment'), 
           scriptType:nextTypeHandler(scriptDetail.rows[0].script_type,'script'),
           genres:scriptDetail.rows[0].genres,
            table:{
            theOrigin:scriptDetail.rows[0].the_origin,
            humanHook:scriptDetail.rows[0].human_hook,
            Desires:scriptDetail.rows[0].desires,
            obstacles:scriptDetail.rows[0].obstacles,
            highlights:scriptDetail.rows[0].highlights,
            openRoad:scriptDetail.rows[0].open_road,
            character:scriptDetail.rows[0].character
            }
        }
        res.json({result,featured:scriptDetail.rows[0].featured})

    }catch(e){
        console.log(e)
    }
})

app.post('/scriptupload',verifyJwt,async(req,res)=>{
    try{
        console.log(req.body)
        console.log('enterd',req.userId)
        const id=req.userId
        const mainScript=req.body.mainScriptId;
        const episode=req.headers["episode"];
        const season=req.headers["season"];
        console.log(mainScript,'scriptId i needed')


        const data=req.body
        console.log(data)
        const entertainmentType=typeHandler(data.entertainmentType,'entertainment')
        const scriptType=typeHandler(data.scriptType,'script')
        console.log(entertainmentType,scriptType)
        const script=await pool.query('INSERT INTO script(scriptwriter_id,featured,is_deleted,main) VALUES($1,$2,$3,$4) RETURNING script_id',
        [id,false,false,mainScript===false?true:false])
        console.log(script)
       
        const  scriptId=script.rows[0]['script_id']
       const scriptDetail= await pool.query('INSERT INTO script_details(script_id,script_title,entertainment,script_type,languages,description,genres,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7,$8)',
        [scriptId,data.titleName,entertainmentType,scriptType,'English',data.description,data.genres,false]);

        if(entertainmentType!=='MOVIE'){
            if(mainScript===false){
           await pool.query('INSERT INTO episodes(script_id,season,episode) VALUES ($1,$2,$3)',[scriptId,1,1])           
            }
            else if(mainScript!==false){
                await pool.query('INSERT INTO episodes (script_id,season,episode) VALUES ($1,$2,$3)',[scriptId,season,episode])
            }
        }
    
    
       const pitchTable=await pool.query('INSERT INTO script_pitch_table(script_id,the_origin,human_hook,character,desires,obstacles,highlights,open_road,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)',
        [scriptId,data['table']['theOrigin'],data['table']['humanHook'],data['table']['character'],data['table']['Desires'],data['table']['obstacles'],data['table']['highlights'],data['table']['openRoad'],false] )
    
        await pool.query('INSERT INTO script_medias(script_id,script_pdf_url,script_poster,script_mini_poster,script_video,is_deleted) VALUES($1,$2,$3,$4,$5,$6)',
        [scriptId,data['pdf'],data['poster'],data['miniPoster'],data['video'],false])
        if(mainScript!==false){
            console.log(mainScript,'pleasssse')
            await pool.query('INSERT INTO series_episodes(main_script,child_script) VALUES ($1,$2)',[mainScript,scriptId])
        }
         res.status(200).json({uploaded:true,scriptId})
    console.log('updated the script upload')
    }catch(err){
        console.log(err)
        res.status(400).json({message:err.message})
    }
        
})

app.post('/episodeCheck',async(req,res)=>{
    try{
const {scriptId,season,episode}=req.body
console.log(req.body)
console.log(scriptId,typeof season,typeof episode)
const mainScript= await pool.query('select * from episodes where script_id=$1 and episode=$2 and season=$3',[scriptId,episode,season])
console.log(mainScript)
if(mainScript.rowCount>0){
    console.log('rows are greater for sure')
    return res.json({notFound:false})
}
else{
    console.log(scriptId,typeof season,episode)
    const script= await pool.query('select * from episodes  JOIN series_episodes  ON episodes.script_id=series_episodes.child_script WHERE series_episodes.main_script=$1 and episodes.season=$2 and episodes.episode= $3',[scriptId,season,episode] )
    if(script.rowCount>0){
        console.log(script.rows)
        return res.json({notFound:false})
    }else{
        return res.json({notFound:true})
    }
}
    }catch(e){
console.log(e)
    }
})

app.get('/fetchscript',async(req,res)=>{
    try{
        console.log('fetching')
        const genre=req.headers["genre"];
        const inDetail=req.headers["indetail"]
        const entertainment=req.headers['type']
        const episodes=req.headers['episodes']
        console.log(req.headers['scriptid'])
        console.log(entertainment)
        // console.log(genre)
        // console.log(inDetail)
        console.log(episodes,'all set for episodessssss')
        if(episodes==='true'){
        console.log(episodes,'all set for episodessssss inside')

            const scriptId=req.headers['scriptid']
            const main=await pool.query('SELECT * FROM series_episodes WHERE main_script=$1 OR child_script=$2',[scriptId,scriptId])
            const mainScript=main.rows[0].main_script
            const scripts = await pool.query('SELECT  script.script_id,script.featured,script_details.script_title,script_details.genres,script_medias.script_poster,episodes.* FROM script_details JOIN script_medias ON script_details.script_id = script_medias.script_id join script on script_details.script_id=script.script_id join series_episodes on script_details.script_id=series_episodes.child_script or script_details.script_id=series_episodes.main_script join episodes on script_details.script_id=episodes.script_id where series_episodes.main_script=$1 and script.script_id!=$2 GROUP BY script.script_id,script_details.script_title,script_details.genres,script_medias.script_poster,episodes.script_id,episodes.episode,episodes.season  ORDER BY episodes.season,episodes.episode',[mainScript,scriptId])
            console.log(scripts)
            let newScriptId={}
            let allScripts=[]
            let genre='More Episodes on This script'
            scripts.rows.map(script=>{
                if(newScriptId[script.script_id]){
                    return
    
                }else{
                    newScriptId[script.script_id]=true
                    allScripts.push(script)
                }
            })
            // const result=scripts.rows
    const result=allScripts
            // const result=scripts.rows
            // console.log(result)
           return res.status(200).json({result,genre})
        }
        

        
        if(inDetail==='true'){
            console.log('in detail')
            const scriptId=req.headers['scriptid']
            const scripts=await pool.query('SELECT  script_details.script_id,script.featured,script_details.script_title,script_details.genres,script_medias.script_poster FROM script_details JOIN script_medias ON script_details.script_id = script_medias.script_id join script on script_details.script_id=script.script_id WHERE $1= ANY(script_details.genres) AND script_details.script_id != $2 AND script.main=$3 ORDER BY script.featured DESC;',[genre,scriptId,true])
            let newScriptId={}
            let allScripts=[]
            scripts.rows.map(script=>{
                if(newScriptId[script.script_id]){
                    return
    
                }else{
                    newScriptId[script.script_id]=true
                    allScripts.push(script)
                }
            })
            // const result=scripts.rows
    const result=allScripts
            // const result=scripts.rows
            // console.log(result)
           return res.status(200).json({result,genre})
        }

        if(entertainment==0){
            console.log(type,'is zerooooo')
            // const scripts=await pool.query('SELECT  script.script_id,script.featured,script_details.script_id,script_details.script_title,script_details.genres,script_medias.script_poster FROM script_details JOIN script_medias ON script_details.script_id = script_medias.script_id join script on script_details.script_id=script.script_id WHERE $1= ANY(script_details.genres) AND script.main=$2 ORDER BY script.featured DESC;',[genre,true]) 
        const scripts=await pool.query('SELECT  script.script_id,script.featured,script_details.script_id,script_details.script_title,script_details.genres,script_medias.script_poster FROM script_details JOIN script_medias ON script_details.script_id = script_medias.script_id join script on script_details.script_id=script.script_id WHERE $1= ANY(script_details.genres)  AND script.main=$2 ORDER BY script.featured DESC;',[genre,true]) 

            let scriptId={}
            let allScripts=[]
            scripts.rows.map(script=>{
                if(scriptId[script.script_id]){
                    return
    
                }else{
                    scriptId[script.script_id]=true
                    allScripts.push(script)
                }
            })
            // const result=scripts.rows
    const result=allScripts
            // console.log(genre,result,'rooooooooooows')
          return res.status(200).json({result,genre})
            

        }

        const scripts=await pool.query('SELECT  script.script_id,script.featured,script_details.script_id,script_details.script_title,script_details.genres,script_medias.script_poster FROM script_details JOIN script_medias ON script_details.script_id = script_medias.script_id join script on script_details.script_id=script.script_id WHERE $1= ANY(script_details.genres) AND script_details.entertainment=$2 AND script.main=$3 ORDER BY script.featured DESC;',[genre,entertainment,true]) 
        let scriptId={}
        let allScripts=[]
        scripts.rows.map(script=>{
            if(scriptId[script.script_id]){
                return

            }else{
                scriptId[script.script_id]=true
                allScripts.push(script)
            }
        })
        // const result=scripts.rows
const result=allScripts
        // console.log(genre,result,'rooooooooooows')
        res.status(200).json({result,genre})

    }catch(e){
        console.log(e)
        res.status(400).json({message:e.message})

    }


    
})

app.get('/scriptdetails',async(req,res)=>{
    try{
        const scriptId=req.headers['scriptid']
        // console.log(scriptId,'*****^^^^^^*****')
        // const scriptDetail= await pool.query(' select scriptwriter.username,script_details.*,script_medias.*,script_pitch_table.* from scripts join scriptwriter on scripts.scriptwriter_id = scriptwriter.scriptwriter_id join script_details on scripts.script_id= $1 join script_medias on scripts.script_id = $2 join script_pitch_table on scripts.script_id=$3',
        // [scriptId,scriptId,scriptId])
          const scriptDetail= await pool.query('select script.featured,script.main,users.username,users.id,script_details.*,script_medias.*,script_pitch_table.* from script join users on script.scriptwriter_id = users.id join script_details on script.script_id= script_details.script_id join script_medias on script.script_id = script_medias.script_id join script_pitch_table on script.script_id=script_pitch_table.script_id WHERE script.script_id=$1',
        [scriptId])
        let episodes
        let episodeState
        if(scriptDetail.rows[0].main){
            episodes=await pool.query('select * from series_episodes where main_script=$1',[scriptId])
        }else{
            episodes=await pool.query('select * from series_episodes where child_script=$1',[scriptId])
        }
        if(episodes.rowCount>0){
            episodeState=true

        }else{
            episodeState=false
        }
        console.log('nodejsssssssssss',scriptDetail.rows[0])
        const result=scriptDetail.rows[0]
        console.log(result)
        res.status(200).json({result,episodeState:episodeState})
    }catch(e){
        res.status(404).json({message:e.message})

    }
    
})

app.post('/writersscripts',async(req,res)=>{
    try{
        const {username}=req.body
        const scripts=await pool.query('SELECT script.script_id,script.featured,script_details.script_title,script_details.genres,script_details.description,script_medias.script_poster,script_medias.script_mini_poster FROM script JOIN script_medias ON script.script_id = script_medias.script_id join script_details on script.script_id=script_details.script_id join users on script.scriptwriter_id=users.id  WHERE users.username=$1',[username])
        let scriptId={}
        let allScripts=[]
        scripts.rows.map(script=>{
            if(scriptId[script.script_id]){
                return

            }else{
                scriptId[script.script_id]=true
                allScripts.push(script)
            }
        })
        // const result=scripts.rows
const result=allScripts
        // console.log(genre,result,'rooooooooooows')
        res.status(200).json(result)

    }catch(e){
console.log(e)
    }
})



app.get('/bannerscript',async(req,res)=>{
    try{
        const scripts=await pool.query('SELECT  script_details.script_id,script_details.script_title,script_details.description,script_medias.script_pdf_url,script_medias.script_poster FROM script_details JOIN script_medias ON script_details.script_id = script_medias.script_id')
        // console.log(scripts.rowCount)
        const index=Math.floor(Math.random()*scripts.rowCount)
        const result=scripts.rows[index]
        res.status(200).json({result})
    }catch(e){
        res.status(400).json({message:e.message})
    }
   
})

app.post('/isSaved',verifyJwt,async (req,res)=>{
    try{
        const userId=req.userId
        const {scriptId}=req.body
        const script= await pool.query('SELECT * FROM saved_scripts WHERE user_id=$1 AND script_id= $2',[userId,scriptId])
        if(script.rowCount>0){
            return res.status(200).json(true)
        }else{
            return res.status(200).json(false)

        }


    }catch(e){
        console.log(e)
    }
})


app.post('/savescript',verifyJwt,async(req,res)=>{
    const {scriptId}=req.body
    const {state}= req.body
    const userId=req.userId
    console.log(scriptId,state)
    if(state===false){
        const addScript=await pool.query('INSERT INTO saved_scripts (user_id,script_id) VALUES ($1,$2)',[userId,scriptId])
        if(addScript.rowCount>0){
         return   res.status(200).json({updated:true})
        }
    }else{
        const removeScript=await pool.query('DELETE FROM saved_scripts WHERE script_id= $1 AND user_id= $2',[scriptId,userId])
        return res.status(200).json({updated:true})
    }
})

app.post('/savedscripts',verifyJwt,async(req,res)=>{
    try{
        const userId=req.userId
        const scripts=await pool.query('SELECT script.script_id,script.featured,script_details.script_title,script_details.genres,script_details.description,script_medias.script_poster,script_medias.script_mini_poster FROM script JOIN script_medias ON script.script_id = script_medias.script_id join script_details on script.script_id=script_details.script_id join users on script.scriptwriter_id=users.id join saved_scripts on script.script_id=saved_scripts.script_id  WHERE saved_scripts.user_id=$1',[userId])
        let scriptId={}
        let allScripts=[]
        scripts.rows.map(script=>{
            if(scriptId[script.script_id]){
                return

            }else{
                scriptId[script.script_id]=true
                allScripts.push(script)
            }
        })
        // const result=scripts.rows
const result=allScripts
        // console.log(genre,result,'rooooooooooows')
        res.status(200).json(result)

    }catch(e){
        console.log(e)

    }
})


// profile





app.post('/getemail',async(req,res)=>{
    const {scriptId}=req.body
    const email=await pool.query('select users.email from script join users on script.scriptwriter_id=users.id where script.script_id=$1',[scriptId])
    res.json(email.rows[0].email)
})

app.post('/getProfileInfo',async(req,res)=>{
try{
    console.log('insider')
const {userid,role}=req.body
console.log(req.body)
console.log(userid)
let details
// if(role==1){
//     console.log('in i n1111111')
//     details=await pool.query('SELECT users.* FROM users WHERE scriptwriter_id=$1',[userid])

// }else{
    details=await pool.query('SELECT users.* FROM users WHERE username=$1',[userid])
    const length=details.rows[0].username.length
    const name=details.rows[0].username
    const username=name.split('')
    const index=username.findIndex(letter=>letter==='@')
    let finalName
    if(index>0){
        const diff=length-index
        const deleted=username.splice(index,diff)
        finalName=username.join('')
    }else{
        finalName=name

    }
    const scriptCount = await pool.query('select count(scriptwriter_id) from script where scriptwriter_id=$1',[details.rows[0].id])
// }
console.log(scriptCount.rows[0].count,'hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii')
const count=scriptCount.rows[0].count

res.json({result:details.rows[0],username:finalName,scriptCount:scriptCount.rows[0].count})
}catch(e){
console.log(e)
}
})
//message
app.post('/addMessage',async(req,res)=>{
    try{
        // console.log(req.body)/
        const {from,to,message}=req.body;
        const data= await messageModel.create({
            message:{text:message},
            users:[from,to],
            sender:from,
        });
        console.log(data)
        if (data) return res.json({ msg: "Message added successfully." });
        else return res.json({ msg: "Failed to add message to the database" });
      } catch (ex) {
        console.log(ex)
        res.json({message:ex})
    }
    })
    
    app.post('/getMessages',async (req, res, next) => {
        try {
            console.log('happening')
          const { from, to } = req.body;
      
          const messages = await messageModel.find({
            users: {
              $all: [from, to],
            },
          }).sort({ updatedAt: 1 });
          if(messages.length>0){
            const projectedMessages = messages.map((msg) => {
                return {
                  fromSelf: msg.sender.toString() === from,
                  message: msg.message.text,
                };
              });
              res.json({projectedMessages,from,to});  
          }
          else{
            res.json({messageStatus:false})
          }
        } catch (ex) {
            console.log(ex)
            res.json({message:ex})
        //   next(ex);
        }
      })


      app.post('/messagedetail',verifyJwt,async(req,res)=>{
        try{console.log('*****************************')
            const userid=req.userId
            console.log(userid)
     const data=await pool.query('SELECT * FROM msg WHERE sender_id=$1  ORDER BY updated_time DESC',[userid])
     console.log(data.rows,'checking messages')
     if(data.rowCount>0){

       return res.json({result:data.rows,message:1})
     }else{
        return res.json({
            message:0
        })

     }

    }catch(e){
        console.error(e)

        }
      })

      app.post('/userDetails',async(req,res)=>{
        try{
            const {id}=req.body
            const {role}=req.body
            console.log(req.body)
            let data
            data=await pool.query('SELECT username from users WHERE id=$1',[id])
        //     if(role==1){
        //          data=await pool.query('SELECT username from scriptwriter WHERE scriptwriter_id=$1',[id])
      
        //     }
        //     if(role===2){
        //        data=await pool.query('SELECT username from producers WHERE producer_id=$1',[id])
      
        //   }
        //   if(role===3){
        //        data=await pool.query('SELECT username from adminPanel WHERER admin_id=$1',[id])
        //   }
          console.log(data)
          res.json({username:data.rows[0].username})
            }catch(e){
                console.error(e)
            }      
        }
       )




      app.post('/messagelist',async(req,res)=>{
        try{
            const {senderId,recieverId,date}=req.body;
            if(senderId===recieverId){
                console.log('cream')
                return res.json({message:'same peroson'})
            }
            const message= await pool.query('SELECT * FROM msg WHERE sender_id=$1 AND reciever_id=$2',[senderId,recieverId])
            if(message.rowCount>0){
              return  res.json({message:'exist'})
            }
            console.log(senderId,recieverId,date)
            const id = await pool.query('INSERT INTO msg (sender_id,reciever_id,updated_time) VALUES($1,$2,$3) RETURNING message_id',[senderId,recieverId,date])
            await pool.query('INSERT INTO msg(message_id,sender_id,reciever_id,updated_time) VALUES($1,$2,$3,$4)',[id.rows[0].message_id,recieverId,senderId,date])

          res.json({message:'success',messageId:id.rows[0].message_id})
  
        }catch(e){
            console.error(e)
  
        }
    })

    app.post('/updateMessageList',async(req,res)=>{
        try{
 const {date,messageId,message}=req.body
 await pool.query('update msg set updated_time=$1,last_msg=$2 where message_id=$3',[date,message,messageId])
 res.json({message:'success'})
        }catch(e){

            console.log(e)
        }
    })

    app.post('/messageId',async(req,res)=>{
        try{
            const {userid,recieverid}=req.body
            console.log(req.body)
            const data= await pool.query('select message_id,reciever_id,sender_id from msg where sender_id=$1 and reciever_id=$2',[userid,recieverid])
            console.log(data)
            res.json({messageId:data.rows[0].message_id,recieverId:data.rows[0].reciever_id,senderId:data.rows[0].sender_id})
        }catch(e){
            console.log(e)
        }
    })
//paytm payment


app.listen(3500,()=>{
    console.log('listening at 4000')
})
const jwtVerify=(token)=>{
    let userId
    if(!token){
        res.send('no token is there')
    }else{
        jwt.verify(token,"jwtsecret",(err,decoded)=>{
            if(err){
                 userId=false
                console.log(userId)
            }else{
                console.log('success verification');
                 userId=decoded.id;
                console.log(userId)
                // req.role=decoded.role
                // return decoded.id 
                // next();
               
               //  console.log(req.userId)
            }
        })
    }
    return userId

}
let onlineUsers=[]


const io =require('socket.io')(3001,{
    cors:{
      origin:['http://localhost:3000'],
      methods: ["GET", "POST"],
      transports: ['websocket', 'polling'],
      credentials: true
    },
  })

  global.onlineUsers= new Map();
  io.use(async function (socket, next) {
    if (socket.handshake.auth && socket.handshake.auth.token) {
        console.log('Inside');
        const userId =  jwtVerify(socket.handshake.auth.token);
        console.log(userId, "-----------------------------------------payload")
        socket['userId'] = userId;
        console.log(socket.userId,socket.id)
        next();
    } else {
        // socket.leave('room')
        next(new Error('Authentication error'));
    }
})
  .on('connection',socket=>{
    // console.log(socket.rooms)
    global.chatSocket=socket;
    socket.on('join-chat',(data=>{
        console.log('joined the chat',data)
        socket.join(data)
    }))
    socket.on('online',async(data)=>{
        if(socket.userId){
            console.log('joinginign ingnignini')


            socket.join(data.room)
            const existingIndex=onlineUsers.findIndex(user=>user.userId===socket.userId)
            const existingUser=onlineUsers[existingIndex]
            let updatedlist
            if(existingUser){
                if(existingUser.socketId===socket.id){
                    return
                }else{
                    const updatedUser={...existingUser,socketId:socket.id}
                    updatedlist=[...onlineUsers]
                    updatedlist[existingIndex]=updatedUser
                }
            }else{
                console.log(onlineUsers,'snakes here*************&&&&&&&')
                updatedlist=onlineUsers.concat({userId:socket.userId,socketId:socket.id})
                console.log(updatedlist)
                // state.users=[...state.users,action.payload.users]


            }
            onlineUsers=updatedlist
            console.log(onlineUsers,'safwan loves kimiko')
            // onlineUsers.push({userId:socket.userId,socketId:socket.id})
            io.to('room').emit('addUserOnline',{
                onlineUsers
            }
                ) 
        }else{
            console.log('leeaving rom amigooooos')
            socket.leave('room')
            const updatedList=onlineUsers.filter(user=>user.socketId!==socket.id)
            onlineUsers=updatedList
            socket.to('room').emit('offlineUsers',{
                socketId:socket.id

            })
        }
       
        // console.log('onlinehandler*************************************',onlineUsers)
        socket.on('checkonline',data=>{
            io.to('room').emit('isonline',{
                status:true,
                id:socket.id
              })
        })
      
       
    })

    // socket.on('checkOnline',async(x)=>{
    //     const currentUsers=await pool.query('select * from onlineusers where user_id=$1',[x])
    //     console.log(currentUsers.rows[0],x,'(((((((((((((((())))))))))))))))))))))))))))))))))))')
    //     io.to('room').emit('isOnline',{
    //         status:currentUsers.rows[0].online_status,
    //         data:currentUsers.rows[0]
    //     })
    // })


    socket.on('offline',async(data)=>{
        console.log('leaving the getScript&&&&&&&&&&&&&&&&&&&&&&&&&')
        socket.leave('room')
        console.log('offflineeees')
        const updatedList=onlineUsers.filter(user=>user.userId!==data.userId)
        onlineUsers=updatedList
        console.log('logingo ut users is ',onlineUsers)


        io.to('room').emit('isonline',{
            userId:data.userId
           
          })

          socket.on('newUsers',(data)=>{
            console.log(data,'sick of this')
            // data.onlineUsers.filter(dat=>dat.socketId!==data.socketId).map(dat=>{
            //     io.to(dat.socket.id).emit('changeIt',{
            //         users:data.onlineUsers
            //     })
            // })
            io.to('room').emit('changeIt',{
                users:data.onlineUsers
            })
          })
        // await pool.query('update onlineusers  set online_status=$1 where user_id=$2',[false,data.userId])
        
        // // let currentOnlineUser=onlineUsers.filter(user=>user!==data.userId)
        // //  onlineUsers=currentOnlineUser
        // //  console.log(onlineUsers)

        // // io.to('room').emit('latestStatus',{
        // //   users:currentOnlineUser
        // // })
    })
    socket.on('changeOnline',(data)=>{
        io.to('room').emit('modify',data.users)
    })
   
    socket.on('join-room',room=>{
        console.log(room,'*************************',socket.id)
        socket.join(room)
        socket.emit('joined-room',{
            message:`succesfully joined room${room}`,
            state:true,
            room:room
        })
    })
    socket.on('leave room',room=>{
        console.log(room,'leaveing')
        socket.leave(room)
    })
    socket.on('fetch-list',async(data)=>{
        try{
            console.log(data,'ehrere is it man')
            const list=await pool.query('SELECT * FROM msg WHERE sender_id=$1  ORDER BY updated_time DESC',[data.userId])
            console.log(list.rows,'seeen')
            socket.emit('list',{
                users:list.rows
            })        
        }catch(e){
            console.log(e)
        }
    
    })
    socket.on('fetch-msg',async(data)=>{
    try{
const msg=await pool.query('select * from msg where sender_id=$1 ORDER BY updated_time DESC',[data.userId])
 socket.emit('last-msg',msg.rows)
    }catch(e){
console.log(e)    
    }
    })
    socket.on('send-msg',(data)=>{
        console.log('hiiiii goood',data)
        socket.broadcast.emit('update-list',data.date)
        io.to(data.to).emit('notifies',{
            messageid:data.room
        })
        // const message=data.msg;
        // const sender=data.from;
        // const reciever=data.to
        const room=data.room
       
        io.to(room).emit('recieve-msg',{
            sender:data.from,
            msg:data.msg,
            reciever:data.to,
            room:data.room

            

        })
        // socket.broadcast.emit('recieve-msg',{
        //     sender:data.from,
        //     msg:data.msg,
        //     reciever:data.to

        // })
    })
  })