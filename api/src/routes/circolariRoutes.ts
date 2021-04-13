import { Router } from "express";
import { Pool } from "pg";

export const circolariRoutes = Router()

circolariRoutes.get("/", async (req, res)=>{
    let circolari;
    if(req.query.nomeSede)
        circolari = await new Pool().query("select numero, titolo, contenuto, nomesede from Circolari where nomeSede=$1", [req.query.nomeSede]);
    else
        circolari = await new Pool().query("select numero, titolo, contenuto, nomesede from Circolari");

    res.status(200).json(circolari.rows)
})