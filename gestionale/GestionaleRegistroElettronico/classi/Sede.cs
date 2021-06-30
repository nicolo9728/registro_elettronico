using GestionaleRegistroElettronico.classi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestionaleRegistroElettronico.Models
{
    public class Sede
    {
        List<Docente> docenti;
        List<Classe> classi;
        List<Circolare> circolari = new List<Circolare>();
        string nome, descrizione;

        public Sede(string nome, string descrizione, List<Docente> docenti, List<Classe> classi)
        {
            Nome = nome;
            Descrizione = descrizione;
            this.docenti = docenti;
            this.classi = classi;

        }

        public Sede(string nome, string descrizione) : this(nome, descrizione, new List<Docente>(), new List<Classe>()) { }

        private Sede() { }

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
        public List<Classe> Classi => classi;

        public List<Circolare> Circolari => circolari;

        public void AggiungiClasse(int anno, string sezione)
        {
            Classe classe = new Classe(anno, sezione, this);
            classi.Add(classe);
        }

        public static Sede fromData(string nome, string descrizione, List<Docente> docenti, List<Classe> classi)
        {
            Sede s = new Sede();
            s.nome = nome;
            s.descrizione = descrizione;
            s.docenti = docenti;
            s.classi = classi;

            return s;
        }

        public void CaricaCircolare(string titolo, string contenuto)
        {
            Circolare c = new Circolare(titolo, contenuto, this);
        }

        public override string ToString()
        {
            return Nome;
        }

    }
}
