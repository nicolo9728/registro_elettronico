import { Router } from "express";
import { Pool } from "pg";
import { controlloLoggato } from "../middleware/controlloLoggato";
import { controlloStudente } from "../middleware/controlloStudente";

export const studenteRoutes = Router()

studenteRoutes.get("/voti", controlloLoggato, controlloStudente, async (req ,res)=>{
    const matricola = req.body.utenteLoggato.matricola

    try{
        const ris = await new Pool().query("SELECT valutazione, data, nomeMateria, descrizione, nome as nomeDocente FROM VOTI natural join Docenti where idStudente=$1", [matricola])
        
        res.status(200).json(ris.rows)
    }
    catch(e){
        res.status(500).send("impossibile ottenere i voti")
    }
})

studenteRoutes.get("/ottieniEventi", controlloLoggato, controlloStudente, async (req, res)=>{
    const data = req.query.data
    const matricola = req.body.utenteLoggato.matricola
    const pool = new Pool()

    try{
        const queryVoti = await pool.query("select valutazione, descrizione, data, nomeMateria, nome as nomeDocente from Voti natural join Docenti where idStudente=$1 and data=$2", [matricola, data])
        const queryPresenze = await pool.query("select data, nome as nomeDocente, cognome as cognomeDocente from presenze natural join Docenti where idStudente=$1 and data=$2", [matricola, data])

        const risposta = {
            voti: queryVoti.rows,
            presenze: queryPresenze.rows
        }

        res.status(200).json(risposta)
    }
    catch(e){
        res.status(400).send(e.message)
    }
})