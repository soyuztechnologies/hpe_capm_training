module.exports = cds.service.impl(async function(){

    const { POs, EmployeeSet } = this.entities;

    //this.before(OPERATION, ENTITY, CODE)
    this.before('UPDATE',EmployeeSet, async (req, res) => {
        console.log(req.data.salaryAmount);
        if(parseFloat(req.data.salaryAmount) >= 1000000){
            req.error(500, "Hey gal! the salary cannot be above 1mn");
        }
        
    });

    this.on('boost', async (req,res) => {
        try {
            
            let ID = req.params[0];
            console.log("Bro the id is " + JSON.stringify(ID));
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: {'+=' : 20000}
            }).where(ID);

            let data = await tx.read(POs).where(ID);
            return data;
            

        } catch (error) {
            
        }
    });

    this.on('getLargestOrder', async (req, res)=>{
        try {
            //create a new transaction object to talk to DB
            const tx = await cds.tx(req);
            ///use tx object to fire READ of data sorted desc order by AMOUNT
            //take the first record
            const data = await tx.read(POs).orderBy({
                GROSS_AMOUNT : 'desc'
            }).limit(1);
            
            if(!data){
                return {
                    "ID": "No Data Found"
                }
            }
            //send data back
            return data;

        } catch (error) {
            return "Some internal error";
        }
    });

});