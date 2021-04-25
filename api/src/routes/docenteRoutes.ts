import { Router } from "express";
import { Pool } from "pg";
import { dbImpostazioni } from "../conf";
import { controlloDocente } from "../middleware/controlloDocente";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const docenteRoutes = Router()

docenteRoutes.post("/aggiungiVoto", controlloLoggato, controlloDocente, async (req, res) => {
    const matricola = req.body.utenteLoggato.matricola
    const { valutazione, descrizione, idStudente, nomeMateria, data } = req.body

    try {
        console.log({ matricola, idStudente })
        const studentiCheInsegna = await new Pool(dbImpostazioni).query(`SELECT 1 from Insegnamenti natural join Classi natural join Studenti where idDocente=${matricola} and idStudente=${idStudente}`)

        if (studentiCheInsegna.rowCount > 0) {
            await new Pool(dbImpostazioni).query(`INSERT into VOTI (valutazione, descrizione, idDocente ,idStudente, nomeMateria, data) values ($1, $2, $3, $4, $5, $6)`, [valutazione, descrizione, matricola, idStudente, nomeMateria, data]);
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
    const pool = new Pool(dbImpostazioni)
    try {
        const docentiDellaClasse = (await pool.query("select 1 from insegnamenti where idClasse=$1 and idDocente=$2", [idClasse, matricola]))

        if(docentiDellaClasse.rowCount>0){
            const studenti = (await pool.query("select matricola, username, nome, cognome, dataNascita, entrata, uscita from Studenti inner join Utenti on (matricola=idStudente) left join Presenze on(Studenti.idStudente = Presenze.idStudente and Presenze.data=$2) where idClasse=$1", [idClasse, new Date()])).rows
            res.status(200).json(studenti)
        }
        else
            throw new Error("il docente non insegna in questa classe")
    }
    catch (e) {
        res.status(400).send(e.message)
    }
})

docenteRoutes.get("/ottieniVoti", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola;
    const idStudente = parseInt(req.query.idStudente as string);
    const pool = new Pool(dbImpostazioni);
    try{
        const ris = await pool.query("select 1 from Studenti natural join Classi natural join Insegnamenti where idDocente = $1 and Studenti.idStudente=$2", [matricola, idStudente]);

        if(ris.rowCount > 0){
            const voti = (await pool.query("select valutazione, descrizione, data, nomeMateria, nome as NomeDocente from voti natural join docenti where idStudente=$1", [idStudente])).rows
            res.status(200).json(voti)
        }
        else
            throw new Error("il docente non insegna a questo studente")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

docenteRoutes.post("/segnaPresenza", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola;
    const idStudente = req.body.idStudente;
    const pool = new Pool(dbImpostazioni);

    try{
        const queryStudente = await pool.query("SELECT 1 from Studenti natural join classi natural join Insegnamenti where idStudente=$1 and idDocente=$2", [idStudente, matricola])
        if(queryStudente.rowCount > 0){
            await pool.query("INSERT into Presenze (idDocente, idStudente, data) values ($1, $2, $3)", [matricola, idStudente, new Date()])
            res.status(200).send("successo")
        }
        else
            throw new Error("il docente non insegna a questo studente")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

docenteRoutes.post("/segnaEntrata", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola
    const idStudente = req.body.idStudente
    const entrata = req.body.entrata
    const pool = new Pool(dbImpostazioni)

    try{
        const queryStudente = await pool.query("SELECT 1 from Studenti natural join classi natural join Insegnamenti where idStudente=$1 and idDocente=$2", [idStudente, matricola])
        if(queryStudente.rowCount>0){
            await pool.query("INSERT into presenze (entrata, idStudente, idDocente, data) values($1, $2, $3, $4) ON CONFLICT (data, idStudente) DO UPDATE set entrata=$1", [entrata, idStudente, matricola, new Date()])
            res.status(200).send("successo")
        }
        else
            throw new Error("il docente non insegna a questo studente")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

docenteRoutes.post("/segnaUscita", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola
    const idStudente = req.body.idStudente
    const uscita = req.body.uscita
    const pool = new Pool(dbImpostazioni)

    try{
        const queryStudente = await pool.query("SELECT 1 from Studenti natural join classi natural join Insegnamenti where idStudente=$1 and idDocente=$2", [idStudente, matricola])
        if(queryStudente.rowCount > 0){
            const ris = await pool.query("UPDATE presenze set uscita=$1 where idStudente=$2 and data=$3", [uscita, idStudente, new Date()])
            if(ris.rowCount > 0)
                res.status(200).send("successo")
            else
                res.status(400).send("lo studente non è mai entrato")
        }
        else
            throw new Error("il docente non insegna a questo studente")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})

docenteRoutes.post("/cancellaPresenza", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola
    const idStudente = req.body.idStudente
    const pool = new Pool(dbImpostazioni);

    try{
        const queryStudente = await pool.query("SELECT 1 from Studenti natural join classi natural join Insegnamenti where idStudente=$1 and idDocente=$2", [idStudente, matricola])
        if(queryStudente.rowCount > 0){
            await pool.query("DELETE from presenze where idStudente=$1 and data=$2", [idStudente, new Date()])
            res.status(200).send("successo")
        }
        else
            throw new Error("il docente non insegna a questo studente")
    }
    catch(e){
        res.status(400).send(e.message)
    }
})