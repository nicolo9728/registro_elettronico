import { compare, genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Utilita } from "../Database";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const utenteRoutes = Router()


utenteRoutes.post("/", async (req, res) => {

    let matricola;

    try {
        const { username, password, tipo, nome, cognome, dataNascita } = req.body

        const salt = await genSalt()
        const passwordCriptata = await hash(password, salt)

        const risultato = await Utilita.db.query(
            "INSERT into Utenti (username, password, tipo) values ($1, $2, $3) returning matricola",
            [username, passwordCriptata, tipo]
        )

        matricola = risultato.rows[0].matricola
        await Utilita.db.query(`INSERT into ${tipo == "Docente"? "Docenti": "Studenti"} (idDocente, nome, cognome, dataNascita) values($1, $2, $3, $4)`, [matricola ,nome, cognome, dataNascita])
        
        const token = sign(username, Utilita.password)
        
        res.status(200).send(token)
    }
    catch (e) {
        if(matricola)
            await Utilita.db.query("DELETE from Utenti where matricola=" + matricola);

        res.status(400).send("dati non validi o username gia esistente: " + e.message)
    }
})

utenteRoutes.post("/login", async (req, res)=>{
    const {username, password} = req.body;
    
    try{
        const ris = await Utilita.db.query("SELECT * from Utenti where username = $1", [username])
        
        if(ris.rowCount == 0)
            throw new Error("username non valido")
        
        
        const utente = ris.rows[0]

        if(await compare(password, utente.password)){
            const token = sign(utente.username, Utilita.password)
            res.status(200).send(token)
        }
        else
            throw new Error("password non valida");
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

utenteRoutes.get("/:tipo", controlloLoggato ,async (req, res)=>{
    const tipo = req.params.tipo;
    const id = req.body.utenteLoggato.matricola;


    try{
        if(tipo != "Docente" && tipo != "Studente")
            throw new Error("tipo non valido");

        const risultato = await Utilita.db.query(`select username, nome, cognome, dataNascita from ${tipo == "Docente"? "Docenti": "Studenti"} inner join Utenti on(id${tipo} = matricola) where id${tipo}=$1`, [id])
        const utente = risultato.rows[0];

        if(risultato.rowCount != 0)
            res.status(200).json(utente)
        else
            throw new Error(`dati non trovati, forse non è un ${tipo}`);
    }
    catch(e){
        res.status(400).send(e.message);
    }
})