import { genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Utilita } from "../Database";

export const docenteRoutes = Router()


docenteRoutes.post("/", async (req, res) => {

    let matricola;

    try {
        const { username, password, nome, cognome, dataNascita } = req.body

        const salt = await genSalt()
        const passwordCriptata = await hash(password, salt)

        const risultato = await Utilita.db.query(
            "INSERT into Utenti (username, password, tipo) values ($1, $2, 'Docente') returning matricola",
            [username, passwordCriptata]
        )

        matricola = risultato.rows[0].matricola
        await Utilita.db.query(`INSERT into Docenti (idDocente, nome, cognome, dataNascita) values($1, $2, $3, $4)`, [matricola, nome, cognome, dataNascita])

        const token = sign(username, Utilita.password)

        res.status(200).send(token)
    }
    catch (e) {
        if (matricola)
            await Utilita.db.query("DELETE from Utenti where matricola=" + matricola);

        res.status(400).send("dati non validi o username gia esistente: " + e.message)
    }
})