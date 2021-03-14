import { Router } from "express";
import { Utilita } from "../Database";
import { controlloDocente } from "../middleware/controlloDocente";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const materieRoutes = Router()

materieRoutes.get("/", async (req, res)=>{
    try{
        const materie = await Utilita.db.query("SELECT * FROM Materie");

        res.status(200).json(materie.rows);
    }
    catch(e){
        res.status(500).send("errore interno")
    }
})

materieRoutes.get("/insegnate", controlloLoggato, controlloDocente, async (req, res)=>{
    const matricola = req.body.utenteLoggato.matricola

    try{
        const materieInsegnate = await Utilita.db.query(`SELECT nomeMateria, descrizione from Competenze natural join Materie where idDocente=${matricola}`)
        res.status(200).json(materieInsegnate.rows)
    }
    catch(e){
        res.status(500).send("errore interno: "+ e.message)
    }
})