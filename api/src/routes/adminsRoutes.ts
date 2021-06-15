import { genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Pool } from "pg";
import { dbImpostazioni } from "../conf";
import { controlloAdmin } from "../middleware/controlloAdmin";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const adminsRoutes = Router()


adminsRoutes.post("/aggiungiMateria",controlloLoggato, controlloAdmin, async (req, res)=>{
    const {nomeMateria, descrizione} = req.body

    try{
        const ris = await new Pool(dbImpostazioni).query("INSERT into Materie (nomeMateria, descrizione) values($1, $2)", [nomeMateria, descrizione])
        res.status(200).send("successo")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

adminsRoutes.post("/aggiungiClasse", controlloLoggato, controlloAdmin, async (req, res)=>{
    const {anno, sezione} = req.body

    try{
        const ris = await new Pool(dbImpostazioni).query("INSERT into Classi (anno, sezione) values($1, $2)", [anno, sezione])
        res.status(200).send("successo")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

adminsRoutes.post("/aggiungiDocente", controlloLoggato, controlloAdmin , async (req, res) => {

    let matricola;

    try {
        const { username, password, nome, cognome, dataNascita, nomeSede } = req.body

        const salt = await genSalt()
        const passwordCriptata = await hash(password, salt)

        const risultato = await new Pool(dbImpostazioni).query(
            "INSERT into Utenti (username, password, tipo, nomeSede, nome, cognome, dataNascita) values ($1, $2, 'Docente', $3, $4, $5, $6) returning matricola",
            [username, passwordCriptata, nomeSede, nome, cognome, dataNascita]
        )
        
        matricola = risultato.rows[0].matricola
        await new Pool(dbImpostazioni).query(`INSERT into Docenti (idDocente) values($1)`, [matricola])

        const token = sign(username,<string>process.env.JWTPASSWORD)

        res.status(200).send(token)
    }
    catch (e) {
        if (matricola)
            await new Pool(dbImpostazioni).query("DELETE from Utenti where matricola=" + matricola);

        res.status(400).send("dati non validi o username gia esistente: " + e.message)
    }
})


adminsRoutes.post("/aggiungiStudente", controlloLoggato ,controlloAdmin , async (req ,res)=>{
    const { username, password, nome, cognome, dataNascita, idClasse, nomeSede } = req.body;
    let matricola;
    try{
        const salt = await genSalt()
        const passwordhash = await hash(password, salt)

        const controlloSede = await new Pool(dbImpostazioni).query("select nomeSede from Classi where idClasse=$1", [idClasse]);
        if(controlloSede.rows[0].nomesede != nomeSede)
            throw new Error("la sede dello studente non corrisponde con la sede della classe")


        const risultato = await new Pool(dbImpostazioni).query("INSERT into UTENTI (username, password, tipo, nomeSede, nome, cognome, dataNascita) values($1, $2, 'Studente', $3, $4, $5, $6) returning matricola", [username, passwordhash, nomeSede, nome, cognome, dataNascita])
        matricola = risultato.rows[0].matricola

        await new Pool(dbImpostazioni).query("INSERT into STUDENTI (idStudente, idClasse) values ($1, $2)", [matricola, idClasse])

        const token = sign(username, <string> process.env.JWTPASSWORD)
        res.status(200).send("successo")
    }
    catch(e){
        if(matricola)
            await new Pool(dbImpostazioni).query("DELETE from Utenti where matricola=" + matricola);
        
        res.status(400).send(e.message)
    }
})

adminsRoutes.post("/", controlloLoggato, controlloAdmin ,async (req, res)=>{
    const {username, password, nome, cognome, dataNascita} = req.body

    const passwordHash = await hash(password, await genSalt(10))
    const pool = new Pool();
    try{
        const ris = await pool.query("INSERT into Utenti (username, password, tipo, nome, cognome, dataNascita) values ($1, $2, $3, $4, $5, $6) returning matricola", [username, passwordHash, "Admin", nome, cognome, dataNascita])
        await pool.query("INSERT into Admins (idAdmin) values ($1)", [ris.rows[0]])
        const token = sign(username, <string>process.env.JWTPASSWORD)
        res.status(200).send(token)
    }
    catch(e){
        res.status(400).send("dati non validi o username gia usato")
    }
})

adminsRoutes.get("/dati/:tabella", controlloLoggato, controlloAdmin, async (req ,res)=>{
    const tipo = req.params.tabella;

    try{
        if(tipo != "docenti" && tipo != "studenti" && tipo != "materie")
            throw new Error("dati non validi")

        const ris = await new Pool(dbImpostazioni).query(`Select * from ${tipo}`)
        
        res.status(200).json(ris.rows)
    }
    catch(e){
        res.status(400).send("dati non validi")
    }
})