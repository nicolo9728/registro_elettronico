export const controlloStudente = (req: any, res: any, next: Function) => {
    if(req.body.utenteLoggato.tipo == "Studente")
        next()
    else
        res.status(400).send("devi essere uno studente per effettuare questa operazione")
}