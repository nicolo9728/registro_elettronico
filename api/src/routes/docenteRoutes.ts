import { genSalt, hash } from "bcrypt";
import { Router } from "express";
import { sign } from "jsonwebtoken";
import { Pool } from "pg";
import { controlloDocente } from "../middleware/controlloDocente";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const docenteRoutes = Router()


docenteRoutes.post("/", async (req, res) => {

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

docenteRoutes.post("/aggiungiVoto", controlloLoggato, controlloDocente, async (req ,res)=>{
    const matricola = req.body.utenteLoggato.matricola
    const {valutazione, descrizione, idStudente, nomeMateria, data} = req.body

    try{
        console.log({matricola, idStudente})
        const studentiCheInsegna = await new Pool().query(`SELECT 1 from Insegnamenti natural join Classi natural join Studenti where idDocente=${matricola} and idStudente=${idStudente}`)

        if(studentiCheInsegna.rowCount > 0){
            await new Pool().query(`INSERT into VOTI (valutazione, descrizione, idDocente ,idStudente, nomeMateria, data) values ($1, $2, $3, $4, $5, $6)`, [valutazione, descrizione,matricola ,idStudente, nomeMateria, data]);
            res.status(200).send("successo")
        }
        else
            throw new Error("questo insegnate non insegna a questo alunno")
    }
    catch(e){
        res.status(400).send(e.message)
    }
    
})