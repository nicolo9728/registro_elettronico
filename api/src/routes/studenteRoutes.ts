import { Router } from "express";
import { Pool } from "pg";
import { dbImpostazioni } from "../conf";
import { controlloLoggato } from "../middleware/controlloLoggato";
import { controlloStudente } from "../middleware/controlloStudente";

export const studenteRoutes = Router()

studenteRoutes.get("/voti", controlloLoggato, controlloStudente, async (req ,res)=>{
    const matricola = req.body.utenteLoggato.matricola

    try{
        const ris = await new Pool(dbImpostazioni).query("SELECT valutazione, data, nomeMateria, descrizione FROM VOTI natural join Docenti where idStudente=$1", [matricola])
        
        res.status(200).json(ris.rows)
    }
    catch(e){
        res.status(500).send(e.message)
    }
})