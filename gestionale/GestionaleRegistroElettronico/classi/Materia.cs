using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;

namespace GestionaleRegistroElettronico.Models
{
    public class Materia
    {
        string nome, descrizione;
        List<Docente> docenti;

        public Materia(string nome, string descrizione, List<Docente> docenti)
        {
            Nome = nome;
            Descrizione = descrizione;
            this.docenti = docenti;

            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand inserisci = new NpgsqlCommand("Insert into Materie (nomemateria, descrizione) values (@nome, @desc)"))
                {
                    inserisci.Parameters.AddWithValue("nome", nome);
                    inserisci.Parameters.AddWithValue("desc", descrizione);
                    inserisci.ExecuteNonQuery();
                }
            }
        }

        private Materia() { }

        public Materia(string nome, string descrizione): this(nome, descrizione, new List<Docente>()) { }

        public string Nome
        {
            get => nome;
            set
            {
                if (value.Length <= 30)
                    nome = value;
                else
                    throw new ArgumentException("il nome non puo superare i 30 caratteri");
            }
        }

        public string Descrizione
        {
            get => descrizione;
            set
            {
                if (value.Length <= 50)
                    descrizione = value;
                else
                    throw new ArgumentException("la descrizione non puo superare i 50 caratteri");
            }
        }


        public List<Docente> Docenti => docenti;

        public static Materia fromData(string nome, string descrizione, List<Docente> docenti)
        {
            Materia materia = new Materia();
            materia.nome = nome;
            materia.descrizione = descrizione;
            materia.docenti = docenti;

            return materia;
        }

        public override string ToString()
        {
            return $"{Nome}";
        }
    }
}
