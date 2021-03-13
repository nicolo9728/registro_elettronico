import { verify } from "jsonwebtoken";
import { Utilita } from "../Database";

export const controlloLoggato = async (req:any, res:any, next:Function)=>{
    const token = req.headers["authorization"];

    try{
        const username = verify(token, Utilita.password);

        if(!username)
            throw new Error("token non valido o inesistente");
        
        const ris = await Utilita.db.query("SELECT * FROM Utenti where username=$1", [username]);
        if(ris.rowCount != 0){
            req.body.utenteLoggato = {
                matricola: ris.rows[0].matricola,
                password: ris.rows[0].password,
                username
            }
            next()
        }
        else
            throw new Error("utente non trovato");

    }
    catch(e){
        res.status(400).send("utente non autorizzato: " + e.message)
    }
}