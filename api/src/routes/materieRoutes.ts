import { Router } from "express";
import { Pool } from "pg";
import { dbImpostazioni } from "../conf";
import { controlloDocente } from "../middleware/controlloDocente";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const materieRoutes = Router()

materieRoutes.get("/", async (req, res)=>{
    try{
        const materie = await new Pool(dbImpostazioni).query("SELECT * FROM Materie");

        res.status(200).json(materie.rows);
    }
    catch(e){
        res.status(500).send("errore interno")
    }
})

materieRoutes.get("/insegnate", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola

    try{
        const materieInsegnate = await new Pool(dbImpostazioni).query(`SELECT nomeMateria as nome, descrizione from Competenze natural join Materie where idDocente=${matricola}`)
        res.status(200).json(materieInsegnate.rows)
    }
    catch(e){
        res.status(500).send("errore interno: "+ e.message)
    }
})