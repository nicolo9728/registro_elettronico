import { Router } from "express";
import { Pool } from "pg";
import { controlloLoggato } from "../middleware/controlloLoggato";
import { controlloStudente } from "../middleware/controlloStudente";

export const studenteRoutes = Router()

studenteRoutes.get("/voti", controlloLoggato, async (req ,res)=>{
    const matricola = req.body.utenteLoggato.matricola

    try{
        const ris = await new Pool().query("SELECT valutazione, data, nomeMateria, descrizione, nome as nomeDocente FROM VOTI natural join Docenti where idStudente=$1", [matricola])
        res.status(200).send(ris.rows)
    }
    catch(e){
        res.status(500).send("impossibile ottenere i voti")
    }
})