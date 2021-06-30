using GestionaleRegistroElettronico.classi;
using GestionaleRegistroElettronico.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace GestionaleRegistroElettronico
{
    /// <summary>
    /// Logica di interazione per GestioneSede.xaml
    /// </summary>
    public partial class GestioneSede : Window
    {
        public Sede Sede { get; set; }
        public GestioneSede(Sede sede)
        {
            InitializeComponent();
            Sede = sede;
            DataContext = sede;
        }

        private void CreaStudente(object sender, RoutedEventArgs e)
        {
            CreaStudente crea = new CreaStudente((Classe)lbxClassi.SelectedItem, Sede);
            if (crea.ShowDialog() == true)
                lbxStudenti.Items.Refresh();
        }

        private void EliminaStudente(object sender, RoutedEventArgs e)
        {
            Studente studente = (Studente)lbxStudenti.SelectedItem;
            studente.Elimina();
            lbxStudenti.Items.Refresh();
        }

        private void TrasferisciStudente(object sender, RoutedEventArgs e)
        {
            Studente studente = (Studente)lbxStudenti.SelectedItem;
            SelezionaRisorsa trasferisci = new SelezionaRisorsa(studente.Sede.Classi);
            if (trasferisci.ShowDialog() == true)
            {
                studente.Classe = (Classe)trasferisci.ElementoSelezionato;
                lbxStudenti.Items.Refresh();
            }
            
        }

        private void CreaClasse(object sender, RoutedEventArgs e)
        {
            CreaClasse classe = new CreaClasse(Sede);
            if (classe.ShowDialog() == true)
                lbxClassi.Items.Refresh();

        }

        private void CreaDocente(object sender, RoutedEventArgs e)
        {
            CreaDocente docente = new CreaDocente(Gestionale.OttieniGestionale(), Sede);
            if (docente.ShowDialog() == true)
                lbxDocenti.Items.Refresh();
        }

        private void EliminaDocente(object sender, RoutedEventArgs e)
        {
            try
            {
                Docente docente = (Docente)lbxDocenti.SelectedItem;
                docente.Elimina();
                lbxDocenti.Items.Refresh();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void AggiungiMateriaDocente(object sender, RoutedEventArgs e)
        {
            List<Materia> materie = Gestionale.OttieniGestionale().Materie;
            SelezionaRisorsa seleziona = new SelezionaRisorsa(materie);
            Docente docente = (Docente)lbxDocenti.SelectedItem;

            if(seleziona.ShowDialog()== true)
            {
                try
                {
                    Materia materiaSelezionata = (Materia)seleziona.ElementoSelezionato;
                    docente.AggiungiMateria(materiaSelezionata);
                    lbxMaterieDocente.Items.Refresh();
                }
                catch(Exception err)
                {
                    MessageBox.Show(err.Message);
                }
            }
        }

        private void RimuoviMateriaDocente(object sender, RoutedEventArgs e)
        {
            Docente docente = (Docente)lbxDocenti.SelectedItem;

            try
            {
                Materia materiaDaRimuovere = (Materia)lbxMaterieDocente.SelectedItem;
                docente.RimuoviMateria(materiaDaRimuovere);
                lbxMaterieDocente.Items.Refresh();
            }
            catch (Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void AggiungiClasseDocente(object sender, RoutedEventArgs e)
        {
            Docente docente = (Docente)lbxDocenti.SelectedItem;
            SelezionaRisorsa seleziona = new SelezionaRisorsa(Sede.Classi);

            if (seleziona.ShowDialog()==true)
            {
                try
                {
                    Classe classeSelezionata = (Classe)seleziona.ElementoSelezionato;
                    docente.AggiungiClasse(classeSelezionata);
                    lbxClassiDocente.Items.Refresh();
                }
                catch(Exception err)
                {
                    MessageBox.Show(err.Message);
                }
            }
        }

        private void RimuoviClasseDocente(object sender, RoutedEventArgs e)
        {
            Classe classe = (Classe)lbxClassiDocente.SelectedItem;
            Docente docente = (Docente)lbxDocenti.SelectedItem;

            try
            {
                docente.RimuoviClasse(classe);
                lbxClassiDocente.Items.Refresh();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }

        }

        private void CreaCircolare(object sender, RoutedEventArgs e)
        {
            try
            {
                Sede.CaricaCircolare(txtTitolo.Text, txtContenuto.Text);
                lbxCircolari.Items.Refresh();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void EliminaCircolare(object sender, RoutedEventArgs e)
        {
            try
            {
                Circolare cir = (Circolare)lbxCircolari.SelectedItem;
                cir.Elimina();
                lbxCircolari.Items.Refresh();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void GestioneStudente(object sender, RoutedEventArgs e)
        {
            Studente studente = (Studente)lbxStudenti.SelectedItem;
            GestioneStudente gestione = new GestioneStudente(studente);
            gestione.ShowDialog();
        }
    }
}
