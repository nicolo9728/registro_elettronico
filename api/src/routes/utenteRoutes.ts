import { compare, genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Pool } from "pg";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const utenteRoutes = Router()

utenteRoutes.post("/login", async (req, res) => {
    const { username, password } = req.body;

    try {
        const ris = await new Pool().query("SELECT * from Utenti where username = $1", [username])

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

utenteRoutes.get("/:tipo", controlloLoggato, async (req, res) => {
    const tipo = req.params.tipo;
    const id = req.body.utenteLoggato.matricola;

    try {
        if (tipo != "Docente" && tipo != "Studente")
            throw new Error("tipo non valido");

        const risultato = await new Pool().query(`select username, nome, cognome, dataNascita from ${tipo == "Docente" ? "Docenti" : "Studenti"} inner join Utenti on(id${tipo} = matricola) where id${tipo}=$1`, [id])
        const utente = risultato.rows[0];

        if (risultato.rowCount != 0)
            res.status(200).json(utente)
        else
            throw new Error(`dati non trovati, forse non è un ${tipo}`);
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
        await new Pool().query(`UPDATE Utenti SET password = $1 where matricola=$2`, [nuovaPassword, matricola])

        res.status(200).send("password modificata con successo");
    }
    catch (e) {
        res.status(400).send("dati non validi: " + e.message)
    }
})