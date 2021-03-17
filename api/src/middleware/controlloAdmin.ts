
export const controlloAdmin = (req: any, res: any, next: Function)=>{
    if(req.body.utenteLoggato.tipo == "Admin")
        next()
    else
        res.status(400).send("devi essere admin per usare questa api")
}