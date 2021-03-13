import { Client, Pool } from "pg"

export class Database{
    static db = new Client({
        user: "postgres",
        password: "1234",
        host: "localhost",
        database: "registro"
    });

}