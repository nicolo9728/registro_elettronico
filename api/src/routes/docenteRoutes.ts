import { Router } from "express";
import { Pool } from "pg";
import { controlloDocente } from "../middleware/controlloDocente";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const docenteRoutes = Router()

docenteRoutes.post("/aggiungiVoto", controlloLoggato, controlloDocente, async (req, res) => {
    const matricola = req.body.utenteLoggato.matricola
    const { valutazione, descrizione, idStudente, nomeMateria, data } = req.body

    try {
        console.log({ matricola, idStudente })
        const studentiCheInsegna = await new Pool().query(`SELECT 1 from Insegnamenti natural join Classi natural join Studenti where idDocente=${matricola} and idStudente=${idStudente}`)

        if (studentiCheInsegna.rowCount > 0) {
            await new Pool().query(`INSERT into VOTI (valutazione, descrizione, idDocente ,idStudente, nomeMateria, data) values ($1, $2, $3, $4, $5, $6)`, [valutazione, descrizione, matricola, idStudente, nomeMateria, data]);
            res.status(200).send("successo")
        }
        else
            throw new Error("questo insegnate non insegna a questo alunno")
    }
    catch (e) {
        res.status(400).send(e.message)
    }

})

docenteRoutes.get("/ottieniStudenti", controlloLoggato, controlloDocente, async (req, res) => {
    const matricola = req.body.utenteLoggato.matricola;
    const idClasse = req.query.idClasse;

    const pool = new Pool()
    try {
        const docentiDellaClasse = (await pool.query("select idDocente from insegnamenti where idClasse=$1", [idClasse]))
            .rows
            .map((ris) => ris = ris.iddocente)

        if(docentiDellaClasse.includes(matricola)){
            const studenti = (await pool.query("select matricola, username, nome, cognome, dataNascita from Studenti inner join Utenti on (matricola=idStudente) where idClasse=$1", [idClasse])).rows
            res.status(200).json(studenti)
        }
        else
            throw new Error("il docente non insegna in questa classe")
    }
    catch (e) {
        res.status(400).send(e.message)
    }
})