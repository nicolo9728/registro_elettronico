import { Router } from "express";
import { Pool } from "pg";
import { dbImpostazioni } from "../conf";
import { controlloAdmin } from "../middleware/controlloAdmin";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const circolariRoutes = Router()

circolariRoutes.get("/", async (req, res)=>{
    let circolari;
    if(req.query.nomeSede)
        circolari = await new Pool(dbImpostazioni).query("select numero, titolo, contenuto, nomesede from Circolari where nomeSede=$1", [req.query.nomeSede]);
    else
        circolari = await new Pool(dbImpostazioni).query("select numero, titolo, contenuto, nomesede from Circolari");

    res.status(200).json(circolari.rows)
})

circolariRoutes.post("/", controlloLoggato, controlloAdmin, async (req, res)=>{
    const {titolo, contenuto} = req.body

    try{
        await new Pool(dbImpostazioni).query("insert into Circolari (titolo, contenuto, idAdmin, nomeSede) values($1, $2, $3, $4)", [titolo, contenuto, req.body.utenteLoggato.matricola, req.body.utenteLoggato.nomeSede]);
        res.status(200).send("successo")
    }
    catch(e){
        res.status(400).send("dati non validi: " + e.message)
    }
})