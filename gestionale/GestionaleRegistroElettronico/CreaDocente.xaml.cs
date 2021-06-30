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
    /// Logica di interazione per CreaDocente.xaml
    /// </summary>
    public partial class CreaDocente : Window
    {
        public Gestionale Gestionale { get; set; }
        public Sede Sede { get; set; }
        public CreaDocente(Gestionale gestionale, Sede sede)
        {
            InitializeComponent();
            Gestionale = gestionale;
            Sede = sede;

            lbxClassi.ItemsSource = Sede.Classi;
            lbxCompetenze.ItemsSource = Gestionale.Materie;
        }

        private void Salva(object sender, RoutedEventArgs e)
        {
            try
            {
                List<Materia> materie = new List<Materia>();
                List<Classe> classi = new List<Classe>();

                foreach(Object c in lbxClassi.SelectedItems)
                {
                    classi.Add((Classe)c);
                }

                foreach(Object m in lbxCompetenze.SelectedItems)
                {
                    materie.Add((Materia)m);
                }


                Docente docente = new Docente(txtNome.Text, txtCognome.Text, txtUsername.Text, txtPassword.Password, (DateTime)dtpNascita.SelectedDate, Sede, materie, classi);
                DialogResult = true;
                Close();
            }
            catch(Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }
    }
}
