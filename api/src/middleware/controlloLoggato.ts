import { verify } from "jsonwebtoken";
import { Pool } from "pg";

export const controlloLoggato = async (req:any, res:any, next:Function)=>{
    const token = req.headers["authorization"];

    try{
        const username = verify(token,<string> process.env.JWTPASSWORD);

        if(!username)
            throw new Error("token non valido o inesistente");
        
        const ris = await new Pool(dbImpostazioni).query("SELECT * FROM Utenti where username=$1", [username]);
        if(ris.rowCount != 0){
            req.body.utenteLoggato = {
                matricola: ris.rows[0].matricola,
                password: ris.rows[0].password,
                tipo: ris.rows[0].tipo,
                nomeSede: ris.rows[0].nomesede,
                username,
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