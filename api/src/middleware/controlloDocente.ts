
export const controlloDocente = (req: any, res: any, next: Function)=>{
    if(req.body.utenteLoggato == "Docente")
        next()
    else
        res.status(400).send("devi essere un docente per effettuare questa operazione")
}