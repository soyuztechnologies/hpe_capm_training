module.exports = (srv) => {
    srv.on('hello',(req,res)=>{
        if(!req.data.name){
            req.data.name = 'sukumar';
        }
        return "Hey Amigo ! " + req.data.name;
    });
}