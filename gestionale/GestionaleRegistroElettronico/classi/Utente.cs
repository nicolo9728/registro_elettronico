using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using static BCrypt.Net.BCrypt;
using Npgsql;

namespace GestionaleRegistroElettronico.Models
{
    public abstract class Utente
    {
        protected string nome, cognome, username, password;
        protected int matricola;
        protected DateTime dataNascita;
        protected Sede sede;

        public Utente(string nome, string cognome, string username, string password, DateTime dataNascita, Sede sede)
        {
            Nome = nome;
            Cognome = cognome;
            Username = username;
            DataNascita = dataNascita;
            this.sede = sede;
            this.password = HashPassword(password, GenerateSalt(10));


            
            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();

                using(NpgsqlCommand inserisciUtente = new NpgsqlCommand("Insert into Utenti (nome, cognome, username, password, datanascita, tipo) values (@nome, @cognome, @username, @password, @data, @tipo) returning matricola", conn))
                {
                    inserisciUtente.Parameters.AddWithValue("nome", nome);
                    inserisciUtente.Parameters.AddWithValue("cognome", cognome);
                    inserisciUtente.Parameters.AddWithValue("username", username);
                    inserisciUtente.Parameters.AddWithValue("password", password);
                    inserisciUtente.Parameters.AddWithValue("data", dataNascita);
                    inserisciUtente.Parameters.AddWithValue("tipo", GetType().Name);

                    matricola = (int)inserisciUtente.ExecuteScalar();
                }
            }
            
        }

        protected Utente() { }

        public string Nome
        {
            get => nome;
            set
            {
                if (value.Length <= 30)
                    nome = value;
                else
                    throw new ArgumentException("Il nome non puo superare i 30 caratteri");
            }
        }

        public string Cognome
        {
            get => cognome;
            set
            {
                if (value.Length <= 30)
                    cognome = value;
                else
                    throw new ArgumentException("Il cognome non puo superare i 30 caratteri");
            }
        }

        public string Username
        {
            get => username;
            set
            {
                if (value.Length <= 30)
                    username = value;
                else
                    throw new ArgumentException("Lo username deve essere inferiore di 30 caratteri");
            }
        }

        public DateTime DataNascita
        {
            get => dataNascita;
            set
            {
                if (dataNascita.CompareTo(DateTime.Now) < 0)
                    dataNascita = value;
                else
                    throw new ArgumentException("Lo studente non puo essere nato domani");
            }
        }

        public int Matricola => matricola;

        abstract public Sede Sede
        {
            get; set;
        }
        

        public override string ToString()
        {
            return $"{Nome} {Cognome}";
        }
        
    }
}
