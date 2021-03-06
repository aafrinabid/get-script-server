require('dotenv').config()
const express=require('express');
const AWS= require('aws-sdk');
const app=express()
const pool=require('./db');
const bcrypt=require('bcrypt');
const cors=require('cors');
const jwt=require('jsonwebtoken');
const multer=require('multer');
const mongoose=require('mongoose');
const messageModel = require('./model/messageModel');
const socket=require('socket.io');
const e = require('express');



app.use(express.json())
app.use(express.urlencoded({extended:true}))
app.use(cors())
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

app.get('/getId',verifyJwt,(req,res)=>{
const userId= req.userId
const role=req.role
res.json({userId,role})
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


           const result=await pool.query('SELECT * FROM users WHERE admin_id=$1',[id])
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
         const NewUser=await pool.query('INSERT INTO users(username,email,firstname,lastname,password,status,is_deleted,TYPE) VALUES($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'pending',false,'producer']);
         const id= NewUser.rows[0].id
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
         const NewUser=await pool.query('INSERT INTO users(username,email,firstname,lastname,password,status,is_deleted,TYPE) VALUES($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *',
         [username,email,firstName,lastName,hashPassword,'approved',false,'scriptwriter']);
         const id= NewUser.rows[0].id
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
        }
    }catch(e){
        console.log(e)
        res.status(400).json({message:e.message})
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
const result=await pool.query('UPDATE users SET is_deleted=$1,status=$2 WHERE id=$3 RETURNING is_deleted,status',[true,'rejected',id])
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
        const producers=await pool.query('SELECT COUNT(id) FROM producers WHERE status=$1 AND TYPE=$2',['approved','producer'])
        const pendingProducers=await pool.query('SELECT COUNT(id) FROM producers WHERE status=$1 AND TYPE=$2 ',['pending','producer'])
        const declinedProducers=await pool.query('SELECT COUNT(id) FROM producers WHERE status=$1 TYPE=$2',['rejected','producer'])
        const producerCount=parseInt(producers.rows[0].count) 
        const pendingProducersCount=parseInt(pendingProducers.rows[0].count)
        const declinedProducersCount=parseInt(declinedProducers.rows[0].count)

        const scriptwriters=await pool.query('SELECT COUNT(id) FROM scriptwriter WHERE status=$1 TYPE=$2',['approved','scriptwriter'])
        const declinedScriptwriters=await pool.query('SELECT COUNT(id) FROM scriptwriter WHERE status=$1 TYPE=$2',['rejected','scriptwriter'])
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
        const admin=await pool.query('SELECT * FROM users WHERE username=$1',[username])
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
    const pendingRequests=await pool.query('SELECT * FROM users WHERE status=$1 AND TYPE=$2',['pending','producer'])
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
        const script=await pool.query('INSERT INTO script(scriptwriter_id,is_deleted) VALUES($1,$2) RETURNING script_id',
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

app.get('/fetchscript',async(req,res)=>{
    try{
        console.log('fetching')
        const genre=req.headers["genre"];
        const inDetail=req.headers["indetail"]
        console.log(req.headers['scriptid'])
        // console.log(genre)
        // console.log(inDetail)
        if(inDetail==='true'){
            console.log('in detail')
            const scriptId=req.headers['scriptid']
            const scripts=await pool.query('SELECT  script_detail.script_id,script_detail.script_title,script_detail.genres,script_media.script_poster FROM script_detail JOIN script_media ON script_detail.script_id = script_media.script_id WHERE $1= ANY(script_detail.genres) AND script_detail.script_id != $2;',[genre,scriptId])
            const result=scripts.rows
            // console.log(result)
           return res.status(200).json({result,genre})
        }

        const scripts=await pool.query('SELECT  script_detail.script_id,script_detail.script_title,script_detail.genres,script_media.script_poster FROM script_detail JOIN script_media ON script_detail.script_id = script_media.script_id WHERE $1= ANY(script_detail.genres);',[genre])
        const result=scripts.rows
        // console.log(result)
        res.status(200).json({result,genre})

    }catch(e){
        console.log('heeeeeey')
        res.status(400).json({message:e.message})

    }


    
})

app.get('/scriptdetails',async(req,res)=>{
    try{
        const scriptId=req.headers['scriptid']
        // console.log(scriptId,'*****^^^^^^*****')
        // const scriptDetail= await pool.query(' select scriptwriter.username,script_detail.*,script_media.*,script_pitch.* from scripts join scriptwriter on scripts.scriptwriter_id = scriptwriter.scriptwriter_id join script_detail on scripts.script_id= $1 join script_media on scripts.script_id = $2 join script_pitch on scripts.script_id=$3',
        // [scriptId,scriptId,scriptId])
          const scriptDetail= await pool.query('select users.username,users.id,script_detail.*,script_media.*,script_pitch.* from script join users on script.scriptwriter_id = users.id join script_detail on script.script_id= script_detail.script_id join script_media on script.script_id = script_media.script_id join script_pitch on script.script_id=script_pitch.script_id WHERE script.script_id=$1',
        [scriptId])
        console.log('nodejsssssssssss',scriptDetail.rows[0])
        const result=scriptDetail.rows[0]
        console.log(result)
        res.status(200).json({result})
    }catch(e){
        res.status(404).json({message:e.message})

    }
    
})

app.get('/bannerscript',async(req,res)=>{
    try{
        const scripts=await pool.query('SELECT  script_detail.script_id,script_detail.script_title,script_detail.description,script_media.script_pdf_url,script_media.script_poster FROM script_detail JOIN script_media ON script_detail.script_id = script_media.script_id')
        // console.log(scripts.rowCount)
        const index=Math.floor(Math.random()*scripts.rowCount)
        const result=scripts.rows[index]
        res.status(200).json({result})
    }catch(e){
        res.status(400).json({message:e.message})
    }
   
})
// profile

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
    details=await pool.query('SELECT users.* FROM users WHERE id=$1',[userid])
// }
console.log(details.rows[0],'hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii')

res.json({result:details.rows[0]})
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


      app.post('/messagedetail',async(req,res)=>{
        try{console.log('*****************************')
            const {userid}=req.body
     const data=await pool.query('SELECT * FROM msg WHERE sender_id=$1  ORDER BY updated_time DESC',[userid])
     if(data.rowCount>0){

        res.json({result:data.rows})
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
                console.log(updatedlist,'fuck sake')
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
        console.log(data,'shits hapeniung cool strut')
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