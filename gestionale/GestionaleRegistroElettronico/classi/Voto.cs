using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;

namespace GestionaleRegistroElettronico.Models
{
    public class Voto
    {

        int valutazione;
        public string Descrizione { get; set; }
        DateTime data;
        public Studente Studente { get; }

        public Voto(int valutazione, Docente docente, Studente studente , Materia materia, DateTime data, string descrizione)
        {
            Docente = docente;
            Materia = materia;
            Valutazione = valutazione;
            Data = data;
            Descrizione = descrizione;

            using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using (NpgsqlCommand caricaVoto = new NpgsqlCommand("Insert into Voti (valutazione, descrizione, data, idstudente, iddocente, nomemateria) values (@val, @desc, @data, @stu, @doc, @mat)", conn))
                {
                    caricaVoto.Parameters.AddWithValue("val", valutazione);
                    caricaVoto.Parameters.AddWithValue("desc", descrizione);
                    caricaVoto.Parameters.AddWithValue("data", data);
                    caricaVoto.Parameters.AddWithValue("stu", studente.Matricola);
                    caricaVoto.Parameters.AddWithValue("doc", docente.Matricola);
                    caricaVoto.Parameters.AddWithValue("mat", materia.Nome);

                    caricaVoto.ExecuteNonQuery();
                }
            }

            Studente = studente;
        }


        private Voto() { }

        public Docente Docente { get; set; }
        public int Id { get; }
        public Materia Materia {get; set;}

        public DateTime Data
        {
            get => data;
            set
            {
                if (value.CompareTo(DateTime.Now) <= 0)
                    data = value;
                else
                    throw new ArgumentException("la data deve essere inferiore di quella di oggi");
            }
        }

        public int Valutazione
        {
            get => valutazione;
            set
            {
                if (value >= 1 && value <= 10)
                    valutazione = value;
                else
                    throw new ArgumentException("La valutazione deve essere compresa tra 1 e 10");
            }
        }

        public static Voto fromData(int valutazione, Docente docente, Materia materia, DateTime data)
        {
            Voto v = new Voto();
            v.valutazione = valutazione;
            v.Docente = docente;
            v.Materia = materia;
            v.data = data;

            return v;
        }

        public override string ToString()
        {
            return $"Valutazione: {valutazione,2}; Docente: {Docente.Nome + " " + Docente.Cognome + ";",-15} Data: {data.ToShortDateString()}";
        }

    }
}
