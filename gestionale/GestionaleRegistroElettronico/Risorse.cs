using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Npgsql;

namespace GestionaleRegistroElettronico
{
    class Risorse
    {
        static string host = "localhost";
        static string user = "postgres";
        static string dbName = "registro";
        static string password = "1234";
        static string port = "5432";

        public static string StringaDiConnessione => $"Server={host};Username={user};Database={dbName};Port={port};Password={password}";
    }
}
