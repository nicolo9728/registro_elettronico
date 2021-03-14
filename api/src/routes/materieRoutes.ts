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