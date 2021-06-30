using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static BCrypt.Net.BCrypt;
using Npgsql;

namespace GestionaleRegistroElettronico.Models
{
    public class Docente: Utente
    {
        List<Materia> materie;
        List<Classe> classi;

        public Docente(string nome, string cognome, string username, string password, DateTime dataNascita, Sede sede, List<Materia> materie, List<Classe> classi):base(nome, cognome, username, password,dataNascita, sede)
        {
            this.materie = materie;
            this.classi = classi;

            sede.Docenti.Add(this);

            using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();

                using (NpgsqlCommand command = new NpgsqlCommand("Insert into Docenti (iddocente) values(@id)", conn))
                {
                    command.Parameters.AddWithValue("id", matricola);
                    command.ExecuteNonQuery();
                }


                /*
                docentiTableAdapter adapter = new docentiTableAdapter();

                adapter.Insert(matricola);

                CompetenzeTableAdapter compAdapter = new CompetenzeTableAdapter();
                insegnamentiTableAdapter insAdapter = new insegnamentiTableAdapter();

                */

                using (NpgsqlCommand inserimentoClassi = new NpgsqlCommand("Insert into Insegnamenti (iddocente, idclasse) values (@doc, @clas)", conn))
                {
                    foreach (Classe classe in classi)
                    {
                        inserimentoClassi.Parameters.Clear();
                        inserimentoClassi.Parameters.AddWithValue("doc", matricola);
                        inserimentoClassi.Parameters.AddWithValue("clas", classe.Id);
                        inserimentoClassi.Prepare();
                        inserimentoClassi.ExecuteNonQuery();

                        classe.Docenti.Add(this);
                    }
                }

                this.classi = classi;

                using(NpgsqlCommand competenze = new NpgsqlCommand("Insert into Competenze (iddocente, nomemateria) values (@doc, @mat)", conn))
                {
                    foreach (Materia materia in materie)
                    {
                        materia.Docenti.Add(this);
                        competenze.Parameters.Clear();
                        competenze.Parameters.AddWithValue("doc", matricola);
                        competenze.Parameters.AddWithValue("mat", materia.Nome);

                        competenze.Prepare();
                        competenze.ExecuteNonQuery();
                    }
                }

                this.materie = materie;

            }

        }

        public Docente(string nome, string cognome, string username,string password ,DateTime dataNascita, Sede sede): this(nome, cognome, username, password, dataNascita,sede , new List<Materia>(), new List<Classe>()) { }


        private Docente() { }

        public List<Materia> Materie => materie;
        public List<Classe> Classi => classi;

        public override Sede Sede
        {
            get => sede;
            set 
            {
                sede.Docenti.Remove(this);
                value.Docenti.Add(this);

                using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
                {
                    conn.Open();
                    using(NpgsqlCommand aggiornaSede = new NpgsqlCommand("Update Utenti set nomesede=@sed where matricola=@id", conn))
                    {
                        aggiornaSede.Parameters.AddWithValue("sed", value.Nome);
                        aggiornaSede.Parameters.AddWithValue("id", matricola);
                        aggiornaSede.ExecuteNonQuery();
                    }
                }
                
                sede = value;
            }
        }

        public void AggiungiMateria(Materia materia)
        {
            if (!materie.Contains(materia))
            {
                materia.Docenti.Add(this);
                materie.Add(materia);

                using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
                {
                    conn.Open();
                    using (NpgsqlCommand inserisciMateria = new NpgsqlCommand("Insert into competenze (iddocente, nomemateria) values (@id, @mat)", conn))
                    {
                        inserisciMateria.Parameters.AddWithValue("id", matricola);
                        inserisciMateria.Parameters.AddWithValue("mat", materia.Nome);
                        inserisciMateria.ExecuteNonQuery();
                    }
                }
            }
        }

        public void RimuoviMateria(Materia materia)
        {

            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand eliminaComp = new NpgsqlCommand("Delete from Competenze where iddocente=@id and nomemateria=@mat", conn))
                {
                    eliminaComp.Parameters.AddWithValue("id", matricola);
                    eliminaComp.Parameters.AddWithValue("mat", materia.Nome);
                    eliminaComp.ExecuteNonQuery();
                }
            }
            
            materie.Remove(materia);
            materia.Docenti.Remove(this);
        }

        public void AggiungiClasse(Classe classe)
        {
            if (!Classi.Contains(classe))
            {

                using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
                {
                    conn.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand("Insert into Insegnamenti (iddocente, idclasse) values (@doc, @clas)", conn))
                    {
                        command.Parameters.AddWithValue("doc", matricola);
                        command.Parameters.AddWithValue("clas", classe.Id);
                        command.ExecuteNonQuery();
                    }
                }

                classe.Docenti.Add(this);
                classi.Add(classe);
            }
        }

        public void RimuoviClasse(Classe classe)
        {
            using (NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();
                using(NpgsqlCommand eliminaClasse = new NpgsqlCommand("Delete from Insegnamenti where idclasse=@clas and iddocente=@doc", conn))
                {
                    eliminaClasse.Parameters.AddWithValue("clas", classe.Id);
                    eliminaClasse.Parameters.AddWithValue("doc", matricola);
                    eliminaClasse.ExecuteNonQuery();
                }
            }

            classi.Remove(classe);
            classe.Docenti.Remove(this);
        }

        public void Elimina()
        {
            using(NpgsqlConnection conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();

                using(NpgsqlCommand eliminaClassi = new NpgsqlCommand("Delete from Insegnamenti where iddocente=@id", conn))
                {
                    eliminaClassi.Parameters.AddWithValue("id", matricola);
                    eliminaClassi.ExecuteNonQuery();
                }

                foreach (Classe classe in classi)
                {
                    classe.Docenti.Remove(this);
                }

                
                
                using(NpgsqlCommand eliminaMaterie = new NpgsqlCommand("Delete from Competenze where iddocente=@id", conn))
                {
                    eliminaMaterie.Parameters.AddWithValue("id", matricola);
                    eliminaMaterie.ExecuteNonQuery();
                }

                foreach (Materia materia in materie)
                {
                    materia.Docenti.Remove(this);
                }

                using(NpgsqlCommand eliminaDocente = new NpgsqlCommand("Delete from Docenti where iddocente=@id", conn))
                {
                    eliminaDocente.Parameters.AddWithValue("id", matricola);
                    eliminaDocente.ExecuteNonQuery();
                }

                using(NpgsqlCommand eliminaUtente = new NpgsqlCommand("Delete from Utenti where matricola=@id", conn))
                {
                    eliminaUtente.Parameters.AddWithValue("id", matricola);
                    eliminaUtente.ExecuteNonQuery();
                }

                sede.Docenti.Remove(this);
            }
        }

        public List<Studente> Studenti
        {
            get
            {
                List<Studente> studenti = new List<Studente>();
                foreach (Classe c in classi)
                {
                    studenti.AddRange(c.Studenti);
                }

                return studenti;
            }
        }

        public static Docente fromData(string nome, string cognome, string username, DateTime dataNascita, Sede sede, List<Materia> materie, List<Classe> classi, int matricola)
        {
            Docente d = new Docente();
            d.nome = nome;
            d.cognome = cognome;
            d.username = username;
            d.dataNascita = dataNascita;
            d.sede = sede;
            d.materie = materie;
            d.classi = classi;
            d.matricola = matricola;

            return d;
        }
    }
}
