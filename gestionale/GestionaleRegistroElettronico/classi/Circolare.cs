using GestionaleRegistroElettronico.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;

namespace GestionaleRegistroElettronico.classi
{
    public class Circolare
    {
        string titolo, contenuto;
        Sede sede;
        int numero;

        public Circolare(string titolo, string contenuto, Sede sede)
        {
            Titolo = titolo;
            Contenuto = contenuto;
            this.sede = sede;
            sede.Circolari.Add(this);

            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand inserimento = new NpgsqlCommand("Insert into Circolari (titolo, contenuto, nomesede) values (@tit, @con, @sede) returning numero", conn))
                {
                    inserimento.Parameters.AddWithValue("tit", titolo);
                    inserimento.Parameters.AddWithValue("con", contenuto);
                    inserimento.Parameters.AddWithValue("sede", Sede.Nome);

                    numero = (int)inserimento.ExecuteScalar();
                }
            }
        }

        private Circolare() { }

        public string Titolo
        {
            get => titolo;
            set
            {
                if (!String.IsNullOrWhiteSpace(value))
                    titolo = value;
                else
                    throw new ArgumentException("Il Titolo non puo essere vuoto");
            }
        }

        public string Contenuto
        {
            get => contenuto;
            set
            {
                contenuto = value;
            }
        }

        public Sede Sede => sede;
        public int Numero => numero;

        public static Circolare fromData(string titolo, string contenuto, int numero, Sede sede)
        {
            Circolare c = new Circolare();
            c.titolo = titolo;
            c.contenuto = contenuto;
            c.numero = numero;
            c.sede = sede;

            return c;
        }

        public override string ToString()
        {
            return $"{Numero}. {Titolo}";
        }

        public void Elimina()
        {
            using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using (NpgsqlCommand eliminazione = new NpgsqlCommand("Delete from Circolari where numero=@num", conn))
                {
                    eliminazione.Parameters.AddWithValue("num", numero);
                    eliminazione.ExecuteNonQuery();
                }
            }

            sede.Circolari.Remove(this);
        }

        public void Aggiorna()
        {
            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand aggiorna = new NpgsqlCommand("Update Circolari set titolo=@tit, contenuto=@cont where numero=@n", conn))
                {
                    aggiorna.Parameters.AddWithValue("tit", titolo);
                    aggiorna.Parameters.AddWithValue("cont", contenuto);
                    aggiorna.Parameters.AddWithValue("n", numero);

                    aggiorna.ExecuteNonQuery();
                }
            }
        }
    }
}
