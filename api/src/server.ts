
import { config } from "dotenv"
import express from "express"
import { docenteRoutes } from "./routes/docenteRoutes"
import { materieRoutes } from "./routes/materieRoutes"
import { studenteRoutes } from "./routes/studenteRoutes"
import { utenteRoutes } from "./routes/utenteRoutes"
const app = express()
const porta = 5000

app.use(express.json())
config()

app.use("/utenti/",utenteRoutes)
app.use("/docenti/", docenteRoutes)
app.use("/studenti/", studenteRoutes)
app.use("/materie/", materieRoutes)

app.listen(porta, ()=>console.log(`server aperto sulla porta ${porta}`))