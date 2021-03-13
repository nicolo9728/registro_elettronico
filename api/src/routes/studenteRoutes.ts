import { genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Utilita } from "../Database";

export const studenteRoutes = Router()

studenteRoutes.post("/", async (req ,res)=>{
    const { username, password, nome, cognome, dataNascita, idClasse } = req.body;
    let matricola;
    try{
        const salt = await genSalt()
        const passwordhash = await hash(password, salt)

        const risultato = await Utilita.db.query("INSERT into UTENTI (username, password, tipo) values($1, $2, 'Studente') returning matricola", [username, passwordhash])
        matricola = risultato.rows[0].matricola

        await Utilita.db.query("INSERT into STUDENTI (idStudente, nome, cognome, dataNascita, idClasse) values ($1, $2, $3, $4, $5)", [matricola, nome, cognome, dataNascita, idClasse])

        const token = sign(username, Utilita.password)
        res.status(200).send(token)
    }
    catch(e){
        if(matricola)
            await Utilita.db.query("DELETE from Utenti where matricola=" + matricola);
        
        res.status(400).send(e.message)
    }
})