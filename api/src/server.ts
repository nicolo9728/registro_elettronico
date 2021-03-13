import express from "express"
import { Client } from "pg"
import { Database } from "./Database"
const app = express()
const porta = 5000

app.use(express.json())


Database.db.connect()
    .then(()=>console.log("database collegato con successo"))
    .catch((err)=>console.log(`impossibile collegarsi al db: ${err.message}`))

app.listen(porta, ()=>console.log(`server aperto sulla porta ${porta}`))