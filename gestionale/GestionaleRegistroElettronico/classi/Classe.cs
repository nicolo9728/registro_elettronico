using System;
using System.Collections.Generic;
using Npgsql;

namespace GestionaleRegistroElettronico.Models
{
    public class Classe
    {
        List<Docente> docenti;
        List<Studente> studenti;
        int anno;
        string sezione;
        int id;

        public Classe(int anno, string sezione, Sede sede, List<Docente> docenti, List<Studente> studenti)
        {
            Anno = anno;
            Sezione = sezione;
            this.docenti = docenti;
            this.studenti = studenti;
            Sede = sede;

            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using (NpgsqlCommand command = new NpgsqlCommand("Insert into Classi(anno, sezione, nomesede) values(@anno, @sezione, @nomesede) returning idclasse", conn))
                {
                    command.Parameters.AddWithValue("anno", anno);
                    command.Parameters.AddWithValue("sezione", sezione);
                    command.Parameters.AddWithValue("nomesede", sede.Nome);
                    id = (int)command.ExecuteScalar();
                }
            }

            Sede.Classi.Add(this);

            foreach(Docente docente in docenti)
            {
                docente.AggiungiClasse(this);
            }

            foreach(Studente studente in studenti)
            {
                studente.Classe = this;
            }
        }

        private Classe()
        {

        }

        public Classe(int anno, string sezione, Sede sede):this(anno, sezione,sede ,new List<Docente>(), new List<Studente>()) { }

        public int Anno
        {
            get => anno;
            set
            {
                if (value >= 1 && value <= 5)
                    anno = value;
                else
                    throw new ArgumentException("l'anno deve essere compreso tra 1 e 5");
            }
        }

        public string Sezione
        {
            get => sezione;
            set
            {
                if (value.Length == 2)
                    sezione = value;
                else
                    throw new ArgumentException("la sezione deve avere 2 caratteri");
            }
        }


        public List<Docente> Docenti => docenti;
        public List<Studente> Studenti => studenti;

        public Sede Sede 
        {
            get;
            private set;
        }


        public int Id => id;

        public static Classe fromData(int anno, string sezione, List<Docente> docenti, List<Studente> studenti, int id, Sede sede)
        {
            Classe c = new Classe();
            c.anno = anno;
            c.sezione = sezione;
            c.docenti = docenti;
            c.studenti = studenti;
            c.id = id;
            c.Sede = sede;

            return c;
        }

        public override string ToString()
        {
            return $"{Anno}{Sezione}";
        }
    }
}
