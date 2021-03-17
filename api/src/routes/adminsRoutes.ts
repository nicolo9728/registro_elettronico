import { genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Pool } from "pg";
import { controlloAdmin } from "../middleware/controlloAdmin";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const adminsRoutes = Router()


adminsRoutes.post("/aggiungiMateria",controlloLoggato, controlloAdmin, async (req, res)=>{
    const {nomeMateria, descrizione} = req.body

    try{
        const ris = await new Pool().query("INSERT into Materie (nomeMateria, descrizione) values($1, $2)", [nomeMateria, descrizione])
        res.status(200).send("successo")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

adminsRoutes.post("/aggiungiClasse", controlloLoggato, controlloAdmin, async (req, res)=>{
    const {anno, sezione} = req.body

    try{
        const ris = await new Pool().query("INSERT into Classi (anno, sezione) values($1, $2)", [anno, sezione])
        res.status(200).send("successo")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

adminsRoutes.post("/aggiungiDocente", controlloLoggato, controlloAdmin , async (req, res) => {

    let matricola;

    try {
        const { username, password, nome, cognome, dataNascita } = req.body

        const salt = await genSalt()
        const passwordCriptata = await hash(password, salt)

        const risultato = await new Pool().query(
            "INSERT into Utenti (username, password, tipo) values ($1, $2, 'Docente') returning matricola",
            [username, passwordCriptata]
        )

        matricola = risultato.rows[0].matricola
        await new Pool().query(`INSERT into Docenti (idDocente, nome, cognome, dataNascita) values($1, $2, $3, $4)`, [matricola, nome, cognome, dataNascita])

        const token = sign(username,<string>process.env.JWTPASSWORD)

        res.status(200).send(token)
    }
    catch (e) {
        if (matricola)
            await new Pool().query("DELETE from Utenti where matricola=" + matricola);

        res.status(400).send("dati non validi o username gia esistente: " + e.message)
    }
})


adminsRoutes.post("/aggiungiStudente", controlloLoggato ,controlloAdmin , async (req ,res)=>{
    const { username, password, nome, cognome, dataNascita, idClasse } = req.body;
    let matricola;
    try{
        const salt = await genSalt()
        const passwordhash = await hash(password, salt)

        const risultato = await new Pool().query("INSERT into UTENTI (username, password, tipo) values($1, $2, 'Studente') returning matricola", [username, passwordhash])
        matricola = risultato.rows[0].matricola

        await new Pool().query("INSERT into STUDENTI (idStudente, nome, cognome, dataNascita, idClasse) values ($1, $2, $3, $4, $5)", [matricola, nome, cognome, dataNascita, idClasse])

        const token = sign(username, <string> process.env.JWTPASSWORD)
        res.status(200).send(token)
    }
    catch(e){
        if(matricola)
            await new Pool().query("DELETE from Utenti where matricola=" + matricola);
        
        res.status(400).send(e.message)
    }
})

adminsRoutes.post("/", controlloLoggato, controlloAdmin ,async (req, res)=>{
    const {username, password} = req.body

    const passwordHash = await hash(password, await genSalt(10))

    try{
        const ris = await new Pool().query("INSERT into Utenti (username, password, tipo) values ($1, $2, $3)", [username, passwordHash, "Admin"])
        const token = sign(username, <string>process.env.JWTPASSWORD)
        res.status(200).send(token)
    }
    catch(e){
        res.status(400).send("dati non validi o username gia usato")
    }
})