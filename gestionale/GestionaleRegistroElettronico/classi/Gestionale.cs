using GestionaleRegistroElettronico.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Npgsql;

namespace GestionaleRegistroElettronico.classi
{
    public class Gestionale
    {
        List<Sede> sedi = new List<Sede>();
        List<Materia> materie = new List<Materia>();
        private static Gestionale gestionale;
        public static Gestionale OttieniGestionale()
        {
            if (gestionale == null)
            {
                gestionale = new Gestionale();
                return gestionale;
            }
            else
                return gestionale;
        }
        private Gestionale()
        {
            /*
            UtentiTableAdapter utentiTableAdapter = new UtentiTableAdapter();
            MaterieTableAdapter materieTableAdapter = new MaterieTableAdapter();
            VotiTableAdapter votiTableAdapter = new VotiTableAdapter();
            CompetenzeTableAdapter competenzeTableAdapter = new CompetenzeTableAdapter();
            SediTableAdapter sediTableAdapter = new SediTableAdapter();
            ClassiTableAdapter classiTableAdapter = new ClassiTableAdapter();
            insegnamentiTableAdapter insegnamentiAdapter = new insegnamentiTableAdapter();
            StudentiTableAdapter studentiAdapter = new StudentiTableAdapter();

            VotiDataTable votiTable = votiTableAdapter.GetData();
            MaterieDataTable materieTable = materieTableAdapter.GetData();
            UtentiDataTable utentiTable = utentiTableAdapter.GetData();
            SediDataTable sediTable = sediTableAdapter.GetData();
            CompetenzeDataTable competenzeTable = competenzeTableAdapter.GetData();
            ClassiDataTable classiTable = classiTableAdapter.GetData();
            insegnamentiDataTable insegnamentiTable = insegnamentiAdapter.GetData();
            StudentiDataTable studentiTable = studentiAdapter.GetData();

            List<Utente> utenti = new List<Utente>();
            List<Classe> classi = new List<Classe>();
            List<Docente> docenti = new List<Docente>();

            foreach (SediRow sede in sediTable)
            {
                sedi.Add(new Sede(sede.nomesede, sede.descrizione));
            }

            foreach(MaterieRow materia in materieTable)
            {
                materie.Add(Materia.fromData(materia.nomemateria, materia.descrizione, new List<Docente>()));
            }

            foreach(ClassiRow classe in classiTable)
            {
                Classe c = Classe.fromData(classe.anno, classe.sezione, new List<Docente>(), new List<Studente>(), classe.idclasse);
                classi.Add(c);
                Sede sede = sedi.Find((s) => s.Nome == classe.nomesede);
                sede.Classi.Add(c);
            }


            foreach(UtentiRow utente in utentiTable.Where((u)=>u.tipo == "Docente"))
            {
                Sede sede = sedi.Find((s) => utente.nomesede == s.Nome);
                List<Materia> materieInsegnate = new List<Materia>();

                Docente docente = Docente.fromData(utente.nome, utente.cognome, utente.username, Convert.ToDateTime(utente.datanascita), sede, new List<Materia>(), new List<Classe>(), utente.matricola);
                sede.Docenti.Add(docente);

                foreach (CompetenzeRow comp in competenzeTable.Where((c)=>c.iddocente == utente.matricola))
                {
                    Materia materia = materie.Find((m) => m.Nome == comp.nomemateria);
                    docente.Materie.Add(materia);
                    materia.Docenti.Add(docente);
                }
                
                foreach(insegnamentiRow ins in insegnamentiTable.Where(i=>i.iddocente == utente.matricola))
                {
                    Classe classe = classi.Find((c) => c.Id == ins.idclasse);
                    docente.Classi.Add(classe);
                    classe.Docenti.Add(docente);
                }

                docenti.Add(docente);
            }

            foreach(UtentiRow utente in utentiTable.Where((u)=>u.tipo == "Studente"))
            {
                Sede sede = sedi.Find((s) => s.Nome == utente.nomesede);
                StudentiRow studenteRow = studentiTable.FindByidstudente(utente.matricola);
                Classe classe = classi.Find((c) => c.Id == studenteRow.idclasse);

                Studente studente = Studente.fromData(utente.nome, utente.cognome, utente.username, Convert.ToDateTime(utente.datanascita), sede, classe, new List<Voto>(), utente.matricola);
                classe.Studenti.Add(studente);

                foreach (VotiRow voto in votiTable.Where((v)=>v.idstudente == utente.matricola))
                {
                    Docente docente = docenti.Find((d) => d.Matricola == voto.iddocente);
                    Materia materia = materie.Find((m) => m.Nome == voto.nomemateria);
                    studente.Voti.Add(Voto.fromData(voto.valutazione, docente, materia, Convert.ToDateTime(voto.data)));
                }
            }
            */

            List<Docente> docenti = new List<Docente>();
            List<Classe> classi = new List<Classe>();
            List<Studente> studenti = new List<Studente>();

            using(var conn = new NpgsqlConnection(Risorse.StringaDiConnessione))
            {
                conn.Open();

                using (NpgsqlCommand command = new NpgsqlCommand("Select * from Sedi", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Sede s = Sede.fromData(reader["nomesede"].ToString(), reader["descrizione"].ToString(), new List<Docente>(), new List<Classe>());
                            sedi.Add(s);
                        }
                    }
                }

                using (NpgsqlCommand command = new NpgsqlCommand("Select * from Materie", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            materie.Add(Materia.fromData(reader["nomemateria"].ToString(), reader["descrizione"].ToString(), new List<Docente>()));
                        }
                    }
                }

                using (NpgsqlCommand command = new NpgsqlCommand("Select * from Utenti where tipo='Docente' ", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Sede s = sedi.Find((s) => s.Nome == reader["nomesede"].ToString());
                            Docente d = Docente.fromData(reader["nome"].ToString(), reader["cognome"].ToString(), reader["username"].ToString(), Convert.ToDateTime(reader["datanascita"]), s, new List<Materia>(), new List<Classe>(), (int)reader["matricola"]);
                            docenti.Add(d);
                            s.Docenti.Add(d);
                        }
                    }
                }

                using (NpgsqlCommand command = new NpgsqlCommand("Select * from Competenze", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Materia materia = materie.Find((m) => m.Nome == reader["nomemateria"].ToString());
                            Docente docente = docenti.Find((d) => d.Matricola == (int)reader["iddocente"]);
                            materia.Docenti.Add(docente);
                            docente.Materie.Add(materia);
                        }
                    }
                }

                using (NpgsqlCommand command = new NpgsqlCommand("Select * from Classi", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Sede sede = sedi.Find((s) => s.Nome == reader["nomesede"].ToString());
                            Classe classe = Classe.fromData((int)reader["anno"], reader["sezione"].ToString(), new List<Docente>(), new List<Studente>(), (int)reader["idclasse"], sede);
                            classi.Add(classe);
                            sede.Classi.Add(classe);
                        }
                    }
                }

                using (NpgsqlCommand command = new NpgsqlCommand("Select * from Utenti inner join Studenti on(idstudente=matricola)", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Sede sede = sedi.Find((s) => s.Nome == reader["nomesede"].ToString());
                            Classe classe = classi.Find((c) => c.Id == (int)reader["idclasse"]);
                            Studente s = Studente.fromData(reader["nome"].ToString(), reader["cognome"].ToString(), reader["username"].ToString(), Convert.ToDateTime(reader["datanascita"]), sede, classe, new List<Voto>(), (int)reader["matricola"]);
                            classe.Studenti.Add(s);
                            studenti.Add(s);
                        }
                    }
                }

                using(NpgsqlCommand command = new NpgsqlCommand("Select * from Voti", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Studente studente = studenti.Find((s) => s.Matricola == (int)reader["idstudente"]);
                            Docente docente = docenti.Find((d) => d.Matricola == (int)reader["iddocente"]);
                            Materia materia = materie.Find(m => m.Nome == reader["nomemateria"].ToString());

                            studente.Voti.Add(Voto.fromData((int)reader["valutazione"], docente, materia, Convert.ToDateTime(reader["data"])));
                        }
                    }
                }

                using(NpgsqlCommand command = new NpgsqlCommand("Select * from Insegnamenti", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Classe classe = classi.Find((c) => c.Id == (int)reader["idclasse"]);
                            Docente docente = docenti.Find((d) => d.Matricola == (int)reader["iddocente"]);
                            docente.Classi.Add(classe);
                            classe.Docenti.Add(docente);
                        }
                    }
                }

                using(NpgsqlCommand command = new NpgsqlCommand("Select * from Circolari", conn))
                {
                    using(var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Sede sede = Sedi.Find((s) => s.Nome == reader["nomesede"].ToString());
                            Circolare circolare = Circolare.fromData(reader["titolo"].ToString(), reader["contenuto"].ToString(), (int)reader["numero"], sede);
                            sede.Circolari.Add(circolare);
                        }
                    }
                }
            }
        }

        public List<Sede> Sedi => sedi;
        public List<Materia> Materie => materie;
    }
}
