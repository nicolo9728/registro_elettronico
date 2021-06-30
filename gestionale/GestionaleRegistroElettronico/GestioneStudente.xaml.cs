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
    /// Logica di interazione per GestioneStudente.xaml
    /// </summary>
    public partial class GestioneStudente : Window
    {
        public Studente Studente { get; set; }
        public GestioneStudente(Studente studente)
        {
            InitializeComponent();
            Studente = studente;
            DataContext = studente;
            for(int i = 1; i<=10; i++)
                cmbValutazione.Items.Add(i);

            cmbValutazione.SelectedIndex = 0;

        }

        private void Aggiungi(object sender, RoutedEventArgs e)
        {
            Docente docente = (Docente)lbxDocenti.SelectedItem;
            Materia materia = (Materia)lbxMateria.SelectedItem;

            try
            {
                Studente.CaricaVoto(docente, (int)cmbValutazione.SelectedItem, txtDescrizione.Text, materia, dtpData.DisplayDate);
                lbxVoti.Items.Refresh();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void Elimina(object sender, RoutedEventArgs e)
        {
            Voto voto = (Voto)lbxVoti.SelectedItem;

            try
            {
                Studente.EliminaVoto(voto);
                lbxVoti.Items.Refresh();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }
    }
}
