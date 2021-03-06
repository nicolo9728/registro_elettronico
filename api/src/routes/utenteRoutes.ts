import { compare, genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Pool } from "pg";
import { dbImpostazioni } from "../conf";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const utenteRoutes = Router()

utenteRoutes.post("/login", async (req, res) => {
    const { username, password } = req.body;

    try {
        const ris = await new Pool(dbImpostazioni).query("SELECT * from Utenti where username = $1", [username])

        if (ris.rowCount == 0)
            throw new Error("username non valido")


        const utente = ris.rows[0]

        if (await compare(password, utente.password)) {
            const token = sign(utente.username, <string>process.env.JWTPASSWORD)
            res.status(200).send(token)
        }
        else
            throw new Error("password non valida");
    }
    catch (e) {
        res.status(400).send(e.message)
    }
})

utenteRoutes.get("/", controlloLoggato, async (req, res) => {
    const id = req.body.utenteLoggato.matricola;

    try {
        
        const pool = new Pool(dbImpostazioni)

        const risultato = await pool.query(`select matricola, username, tipo, nomeSede, nome, cognome, dataNascita from Utenti where matricola=$1`, [id]);
        let utente = risultato.rows[0];

        if(!utente)
            throw new Error("utente non trovato")

        if(utente.tipo == "Docente"){
            const materieInsegnate = (await pool.query("select nomeMateria as nome, descrizione from Docenti natural join competenze natural join materie where idDocente=$1", [utente.matricola])).rows
            const classi = (await pool.query("select idClasse, anno || sezione as nome from Docenti natural join insegnamenti natural join classi where idDocente=$1", [utente.matricola])).rows

            utente.materie = materieInsegnate
            utente.classi = classi
        }

        if(utente.tipo == "Studente"){
            const dati = await pool.query("select entrata, uscita from Studenti left join Presenze on (Presenze.idStudente=$1 and Presenze.data=$2) where Studenti.idStudente=$1", [id, new Date()]);
            const voti = (await pool.query("select valutazione, descrizione, data, nomeMateria, nome as NomeDocente from voti natural join docenti inner join Utenti on (idStudente = matricola) where idStudente=$1", [id])).rows
            utente = {
                ...utente,
                ...dati.rows[0]
            }
            utente.voti = voti
        }

        if (risultato.rowCount != 0)
            res.status(200).json(utente)
        else
            throw new Error(`dati non trovati`);
    }
    catch (e) {
        res.status(400).send(e.message);
    }
})

utenteRoutes.post("/aggiornaPassword", controlloLoggato, async (req, res) => {
    const matricola = req.body.utenteLoggato.matricola;
    let nuovaPassword = req.body.password

    try {

        const salt = await genSalt()
        nuovaPassword = await hash(nuovaPassword, salt)
        await new Pool(dbImpostazioni).query(`UPDATE Utenti SET password = $1 where matricola=$2`, [nuovaPassword, matricola])

        res.status(200).send("password modificata con successo");
    }
    catch (e) {
        res.status(400).send("dati non validi: " + e.message)
    }
})