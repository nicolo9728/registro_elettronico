import express from "express"
const app = express()
const porta = 5000

app.use(express.json())


app.listen(porta, ()=>console.log(`server aperto sulla porta ${porta}`))