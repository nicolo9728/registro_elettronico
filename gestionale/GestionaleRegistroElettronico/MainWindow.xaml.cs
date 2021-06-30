using GestionaleRegistroElettronico.classi;
using GestionaleRegistroElettronico.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace GestionaleRegistroElettronico
{
    public partial class MainWindow : Window
    {
        public Gestionale Gestionale { get; set; }
        public MainWindow()
        {
            InitializeComponent();
            Gestionale = Gestionale.OttieniGestionale();
            DataContext = Gestionale.Sedi;
        }

        private void CreaDocente(object sender, RoutedEventArgs e)
        {
            try
            {
                Sede s = (Sede)lbxSedi.SelectedItem;

                if (s == null)
                    throw new ArgumentException("Sede non selezioanta");

                (new CreaDocente(Gestionale, s)).ShowDialog();
                lbxDocenti.Items.Refresh();

            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void EliminaDocente(object sender, RoutedEventArgs e)
        {
            try
            {
                Docente d = (Docente)lbxDocenti.SelectedItem;
                d.Elimina();
                lbxDocenti.Items.Refresh();

            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }

        private void GestioneSede(object sender, RoutedEventArgs e)
        {
            if (lbxSedi.SelectedItem == null)
            {
                MessageBox.Show("Prima devi selezionare la sede");
                return;
            }

            GestioneSede gestione = new GestioneSede((Sede)lbxSedi.SelectedItem);
            gestione.Show();
        }
    }
}
