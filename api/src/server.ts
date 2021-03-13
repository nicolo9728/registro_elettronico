import express from "express"
import { Client } from "pg"
import { Utilita } from "./Database"
import { utenteRoutes } from "./routes/utenteRoutes"
const app = express()
const porta = 5000

app.use(express.json())


Utilita.db.connect()
    .then(()=>console.log("database collegato con successo"))
    .catch((err)=>console.log(`impossibile collegarsi al db: ${err.message}`))


app.use("/utenti/",utenteRoutes)

app.listen(porta, ()=>console.log(`server aperto sulla porta ${porta}`))