import express from "express"
import { Utilita } from "./Database"
import { docenteRoutes } from "./routes/docenteRoutes"
import { studenteRoutes } from "./routes/studenteRoutes"
import { utenteRoutes } from "./routes/utenteRoutes"
const app = express()
const porta = 5000

app.use(express.json())


Utilita.db.connect()
    .then(()=>console.log("database collegato con successo"))
    .catch((err)=>console.log(`impossibile collegarsi al db: ${err.message}`))


app.use("/utenti/",utenteRoutes)
app.use("/docenti/", docenteRoutes)
app.use("/studenti/", studenteRoutes)


app.listen(porta, ()=>console.log(`server aperto sulla porta ${porta}`))