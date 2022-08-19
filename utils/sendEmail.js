require('dotenv').config()
// console.log('same',process.env.BUCKET_NAME)
const nodemailer=require('nodemailer')
// console.log(process.env.Node_mailer_Pass)

module.exports=async(email,subject,text,pass)=>{
    try{
        const transporter=nodemailer.createTransport({
            service:'hotmail',
            port:587,
            host:'smtp.office365.com',
            auth:{
                user:'getscript@outlook.com',
                pass:pass
    }
    });
    
    const option ={
        from:'getscript@outlook.com',
        to:email,
        subject:subject,
        text:text
    }

  await  transporter.sendMail(option)
  console.log('email sent succesfully')
            
    }catch(e){
        console.log('email not sent')
        console.log(e)
        return e
    }
}
// const transporter=nodemailer.createTransport({
//         service:'hotmail',
//         port:587,
//         host:'smtp.office365.com',
//         auth:{
//             user:'getscript@outlook.com',
//             pass:''
// }
// });

// const option ={
//     from:'getscript@outlook.com',
//     to:'mohdaafrin@outlook.com',
//     subject:'SENDING EMAIL',
//     text:'this is simple'
// }

// transporter.sendMail(option,function(err,info){
//     if(err){
//         console.log(err)
//         return
//     }
//     console.log('sent'+info.response)
// })