require('dotenv').config()
const express=require('express');
const AWS= require('aws-sdk');
const app=express()
const pool=require('./db');
const bcrypt=require('bcrypt');
const cors=require('cors');
const jwt=require('jsonwebtoken');
const multer=require('multer');
const cookieParser = require('cookie-parser');
const session=require('express-session');


app.use(express.json())
app.use(express.urlencoded({extended:true}))
app.use(cors())

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
const verifyJwt=(req,res,next)=>{
    const token=req.headers["x-access-token"];

    if(!token){
        res.send('no token is there')
    }else{
        jwt.verify(token,"jwtsecret",(err,decoded)=>{
            if(err){
                return res.json({auth:false,message:'authorization failed'})
            }else{
                console.log('success verification');
                req.userId=decoded.id;
                req.role=decoded.role
               
               //  console.log(req.userId)
                next();
            }
        })
    }

}
app.get('/isAuth',verifyJwt,async(req,res)=>{
    try{console.log(process.env.BUCKET_STORAGE_URL)
        const token=req.headers['x-access-token'];
    const id=req.userId
    const role=req.role
    console.log(id,role);
   let status
    if(role===1){
    console.log('user is script type');
    console.log('sfjkskf')


           const result=await pool.query('SELECT * FROM scriptwriter WHERE scriptwriter_id=$1',[id])
           console.log(result.rows)
           status=result.rows[0]['status']
           console.log(status,'coool')
           if(status==='approved'){

            res.json({auth:true,message:'you are authenticated',id,token,role,status})
        }else({auth:false,message:'not authorised yet',role,status})

    }
    if(role===2){
    console.log('user is script producer');
    const result=await pool.query('SELECT * FROM producers WHERE producer_id=$1',[id])
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


           const result=await pool.query('SELECT * FROM adminPanel WHERE admin_id=$1',[id])
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
//producer
app.post('/registerProducer',async(req,res)=>{
    try{
        const {username,password,email,firstName,lastName}=req.body;
        console.log(password,username)
        // if(username='aafrin'){
        //     console.log('not happening in usernaem')
        //     res.status(400).json({auth:false,message:'username already exist'})
        // }
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
         const role=2
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
        const user= await pool.query('SELECT * FROM producers WHERE username=$1',[username])
        if(user.rowCount===1){
            console.log(user.rows[0].password)
            const compPass= await bcrypt.compare(password,user.rows[0].password)
            if(compPass){
                const id=user.rows[0].producer_id
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
        const user=await pool.query('SELECT * FROM scriptwriter WHERE username=$1',[username]);
        const useremail= await pool.query('SELECT * FROM scriptwriter WHERE email=$1',[email])
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
         const NewUser=await pool.query('INSERT INTO scriptwriter(username,email,firstname,lastname,password,status,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'approved',false]);
         const id= NewUser.rows[0].scriptwriter_id
         const role=1
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
        const user= await pool.query('SELECT * FROM scriptwriter WHERE username=$1',[username])
        if(user.rowCount===1){
            console.log(user.rows[0].password)
            const compPass= await bcrypt.compare(password,user.rows[0].password)
            if(compPass){
                const id=user.rows[0].scriptwriter_id
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
        }
    }catch(e){
        res.status(400).json({message:e.message})
    }
})

//adminpanel
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
        const fetchedProducers=await pool.query('SELECT * FROM producers WHERE is_deleted=$1' ,[false])
        const result=fetchedProducers.rows;
        console.log(result)

        res.status(200).json({result})
    }catch(e){
        res.status(400).json({message:e.message})
    }
  

})

app.get('/getUserCount',async(req,res)=>{
    try{
        const producers=await pool.query('SELECT COUNT(producer_id) FROM producers WHERE status=$1',['approved'])
        const pendingProducers=await pool.query('SELECT COUNT(producer_id) FROM producers WHERE status=$1',['pending'])
        const declinedProducers=await pool.query('SELECT COUNT(producer_id) FROM producers WHERE status=$1',['rejected'])
        const producerCount=parseInt(producers.rows[0].count) 
        const pendingProducersCount=parseInt(pendingProducers.rows[0].count)
        const declinedProducersCount=parseInt(declinedProducers.rows[0].count)

        const scriptwriters=await pool.query('SELECT COUNT(scriptwriter_id) FROM scriptwriter WHERE status=$1',['approved'])
        const declinedScriptwriters=await pool.query('SELECT COUNT(scriptwriter_id) FROM scriptwriter WHERE status=$1',['rejected'])
        const scriptwriterCount=parseInt(scriptwriters.rows[0].count)
        const declinedScriptwritersCount=parseInt(declinedScriptwriters.rows[0].count)

        const totalUsers=scriptwriterCount+producerCount
        const blockedUsers=declinedProducersCount+declinedScriptwritersCount;
        res.status(200).json({scriptwriterCount,producerCount,totalUsers,pendingProducersCount,declinedProducersCount,declinedScriptwritersCount,blockedUsers})


    }catch(e){
        console.error(e)

    }
})

app.post('/adminlogin',async(req,res)=>{
    try{
        const {username,password}=req.body;
        const admin=await pool.query('SELECT * FROM adminPanel WHERE username=$1',[username])
        if(admin.rowCount===1){
            if(admin.rows[0]['password']===password){
                console.log(admin.rows[0])
                const role=3;
                const id=admin.rows[0]['admin_id']
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
    const pendingRequests=await pool.query('SELECT * FROM producers WHERE status=$1',['pending'])
    if(pendingRequests.rowCount>0){
        const result=pendingRequests.rows

        res.status(200).json({result})
    }
})

//script


app.post('/uploadscript',upload.single('file'),(req,res)=>{
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
    
})
const typeHandler=(type,name)=>{
    console.log('in type')
if(name==='entertainment'){
    if(type===10){
        return 'MOVIE'
    }
    if(type===20){
        return 'TV Series'
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

app.post('/scriptupload',verifyJwt,async(req,res)=>{
    try{
        console.log('enterd',req.userId)
        const id=req.userId
        const data=req.body
        console.log(data)
        const entertainmentType=typeHandler(data.entertainmentType,'entertainment')
        const scriptType=typeHandler(data.scriptType,'script')
        console.log(entertainmentType,scriptType)
        const script=await pool.query('INSERT INTO scripts(scriptwriter_id,is_deleted) VALUES($1,$2) RETURNING script_id',
        [id,false])
        console.log(script)
       
        const  scriptId=script.rows[0]['script_id']
       const scriptDetail= await pool.query('INSERT INTO script_detail(script_id,script_title,entertainment,script_type,languages,description,genres,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7,$8)',
        [scriptId,data.titleName,entertainmentType,scriptType,'English',data.description,data.genres,false]);
    
    
       const pitchTable=await pool.query('INSERT INTO script_pitch(script_id,the_origin,human_hook,character,desires,obstacles,highlights,open_road,is_deleted) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)',
        [scriptId,data['table']['theOrigin'],data['table']['humanHook'],data['table']['character'],data['table']['Desires'],data['table']['obstacles'],data['table']['highlights'],data['table']['openRoad'],false] )
    
        await pool.query('INSERT INTO script_media(script_id,script_pdf_url,script_poster,script_mini_poster,script_video,is_deleted) VALUES($1,$2,$3,$4,$5,$6)',
        [scriptId,data['pdf'],data['poster'],data['miniPoster'],data['video'],false])
         res.status(200).json({uploaded:true})
    
    }catch(err){
        res.status(400).json({message:err.message})
    }
        
})

app.get('/fetchscript',(req,res)=>{
    
})




app.listen(4000,()=>{
    console.log('listening at 4000')
})