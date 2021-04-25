import { Router } from "express";
import { Pool } from "pg";
import { controlloLoggato } from "../middleware/controlloLoggato";

export const eventiRoutes = Router()

eventiRoutes.get("/", controlloLoggato, async (req, res)=>{
    const data = req.query.data
        const matricola = req.body.utenteLoggato.matricola
        const tipo = req.body.utenteLoggato.tipo;
        const pool = new Pool(dbImpostazioni)
    
        try{
            let risposta = {};
            if(tipo == "Studente"){
                const queryVoti = await pool.query("select valutazione, descrizione, data, nomeMateria, nome from Voti natural join Docenti where idStudente=$1 and data=$2", [matricola, data])
                const queryPresenze = await pool.query("select idStudente, entrata, uscita,data, nome as nomeDocente, cognome as cognomeDocente from presenze natural join Docenti where idStudente=$1 and data=$2", [matricola, data])
        
                risposta = {
                    voti: queryVoti.rows,
                    presenze: queryPresenze.rows
                }
            }
            else{
                const queryVoti = await pool.query("select valutazione, descrizione, data, nomeMateria, nome from Voti natural join Studenti where idDocente=$1 and data=$2", [matricola, data])
                risposta = {
                    voti: queryVoti.rows
                }
            }


            res.status(200).json(risposta)
        }
        catch(e){
            res.status(400).send(e.message)
        }
})