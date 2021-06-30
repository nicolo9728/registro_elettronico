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
    /// Logica di interazione per CreaStudente.xaml
    /// </summary>
    public partial class CreaStudente : Window
    {
        Classe classe;
        Sede sede;
        public CreaStudente(Classe classe, Sede sede)
        {
            InitializeComponent();
            this.classe = classe;
            this.sede = sede;
        }

        private void Crea(object sender, RoutedEventArgs e)
        {
            try
            {
                Studente studente = new Studente(txtNome.Text, txtCognome.Text, txtUsername.Text, txtPassword.Password, dtpNascita.DisplayDate, sede, classe);
                DialogResult = true;
                Close();
            }
            catch (Exception err)
            {
                MessageBox.Show(err.Message);
            }
        }
    }
}
