using System;
using System.Collections.Generic;
using Npgsql;
using static BCrypt.Net.BCrypt;

namespace GestionaleRegistroElettronico.Models
{
    public class Studente: Utente
    {
        Classe classe;
        List<Voto> voti;

        public Studente(string nome, string cognome, string username, string password, DateTime dataNascita, Sede sede, Classe classe): base(nome, cognome, username, password, dataNascita, sede)
        {
            if (classe.Sede != sede)
                throw new ArgumentException("la classe inserita non appartiene alla sede dello studente");

            voti = new List<Voto>();
            this.classe = classe;
            
            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand command = new NpgsqlCommand("Insert into studenti (idstudente, idclasse) values (@stu, @clas)", conn))
                {
                    command.Parameters.AddWithValue("stu", matricola);
                    command.Parameters.AddWithValue("clas", classe.Id);
                    command.ExecuteNonQuery();
                }
            }

            classe.Studenti.Add(this);
        }

        private Studente() { }

        public override Sede Sede
        {
            get => sede;
            set => throw new ArgumentException("Per modificare la sede bisogna modificare la classe");
        }

        public Classe Classe
        {
            get => classe;
            set
            {
                if (value.Sede == sede)
                {
                    classe.Studenti.Remove(this);
                    value.Studenti.Add(this);

                    using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
                    {
                        conn.Open();
                        using (NpgsqlCommand aggiornaClasse = new NpgsqlCommand("Update Studenti set idClasse=@clas where idstudente=@stu", conn))
                        {
                            aggiornaClasse.Parameters.AddWithValue("clas", value.Id);
                            aggiornaClasse.Parameters.AddWithValue("stu", matricola);
                            aggiornaClasse.ExecuteNonQuery();
                        }
                    }
                    classe = value;

                }
                else
                    throw new ArgumentException("La classe si trova su un'altra sede");
            }
        }


        public void CaricaVoto(Docente docente, int valutazione, string descrizione, Materia materia, DateTime data)
        {
            Voto v = new Voto(valutazione, docente, this, materia , data, descrizione);

            voti.Add(v);
        }

        public void EliminaVoto(Voto voto)
        {
            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand eliminazione = new NpgsqlCommand("Delete from Voti where idvoto=@id", conn))
                {
                    eliminazione.Parameters.AddWithValue("id", voto.Id);
                    eliminazione.ExecuteNonQuery();
                }

                voti.Remove(voto);
            }
        }

        public void Elimina()
        {
            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();

                using(NpgsqlCommand eliminaVoti = new NpgsqlCommand("Delete from Voti where idstudente=@id", conn))
                {
                    eliminaVoti.Parameters.AddWithValue("id", matricola);
                    eliminaVoti.ExecuteNonQuery();
                }

                using(NpgsqlCommand eliminaStudente = new NpgsqlCommand("Delete from Studenti where idstudente=@id", conn))
                {
                    eliminaStudente.Parameters.AddWithValue("id", matricola);
                    eliminaStudente.ExecuteNonQuery();
                }

                using(NpgsqlCommand eliminaUtente = new NpgsqlCommand("Delete from Utenti where matricola=@id", conn))
                {
                    eliminaUtente.Parameters.AddWithValue("id", matricola);
                    eliminaUtente.ExecuteNonQuery();
                }
            }

            classe.Studenti.Remove(this);

        }


        public List<Voto> Voti => voti;

        public static Studente fromData(string nome, string cognome, string username, DateTime dataNascita, Sede sede, Classe classe, List<Voto> voti, int matricola)
        {
            Studente s = new Studente();
            s.nome = nome;
            s.cognome = cognome;
            s.username = username;
            s.dataNascita = dataNascita;
            s.sede = sede;
            s.classe = classe;
            s.voti = voti;
            s.matricola = matricola;

            return s;
        }
    }
}