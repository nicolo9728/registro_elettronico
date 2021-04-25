import { config } from "dotenv"
import express from "express"
import { adminsRoutes } from "../src/routes/adminsRoutes"
import { circolariRoutes } from "../src/routes/circolariRoutes"
import { docenteRoutes } from "../src/routes/docenteRoutes"
import { eventiRoutes } from "../src/routes/eventiRoutes"
import { materieRoutes } from "../src/routes/materieRoutes"
import { studenteRoutes } from "../src/routes/studenteRoutes"
import { utenteRoutes } from "../src/routes/utenteRoutes"


const app = express()
const porta = 5000

app.use(express.json())
config()

app.use("/utenti/",utenteRoutes)
app.use("/docenti/", docenteRoutes)
app.use("/studenti/", studenteRoutes)
app.use("/materie/", materieRoutes)
app.use("/admins/", adminsRoutes)
app.use("/circolari/", circolariRoutes)
app.use("/eventi/", eventiRoutes)

app.listen(porta, ()=>console.log(`server aperto sulla porta ${porta}`))