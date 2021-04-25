import { genSalt, hash } from "bcryptjs";
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
        const { username, password, nome, cognome, dataNascita, nomeSede } = req.body

        const salt = await genSalt()
        const passwordCriptata = await hash(password, salt)

        const risultato = await new Pool().query(
            "INSERT into Utenti (username, password, tipo) values ($1, $2, 'Docente', $3) returning matricola",
            [username, passwordCriptata, nomeSede]
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
    const { username, password, nome, cognome, dataNascita, idClasse, nomeSede } = req.body;
    let matricola;
    try{
        const salt = await genSalt()
        const passwordhash = await hash(password, salt)

        const controlloSede = await new Pool().query("select nomeSede from Classi where idClasse=$1", [idClasse]);
        if(controlloSede.rows[0].nomesede != nomeSede)
            throw new Error("la sede dello studente non corrisponde con la sede della classe")


        const risultato = await new Pool().query("INSERT into UTENTI (username, password, tipo, nomeSede) values($1, $2, 'Studente', $3) returning matricola", [username, passwordhash, nomeSede])
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

adminsRoutes.get("/dati/:tabella", controlloLoggato, controlloAdmin, async (req ,res)=>{
    const tipo = req.params.tabella;

    try{
        if(tipo != "docenti" && tipo != "studenti" && tipo != "materie")
            throw new Error("dati non validi")

        const ris = await new Pool().query(`Select * from ${tipo}`)
        
        res.status(200).json(ris.rows)
    }
    catch(e){
        res.status(400).send("dati non validi")
    }
})