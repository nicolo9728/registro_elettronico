import { Client, Pool } from "pg"

export class Utilita{
    static db = new Client({
        user: "postgres",
        password: "1234",
        host: "localhost",
        database: "registro"
    });

    static password = "1234"
}