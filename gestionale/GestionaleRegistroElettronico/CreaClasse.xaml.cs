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
    /// Logica di interazione per CreaClasse.xaml
    /// </summary>
    public partial class CreaClasse : Window
    {
        public Sede Sede { get; }

        public CreaClasse(Sede sede)
        {
            InitializeComponent();
            Sede = sede;
        }

        private void Crea(object sender, RoutedEventArgs e)
        {
            try
            {
                Classe classe = new Classe(Convert.ToInt32(nudAnno.Text), txtSezione.Text, Sede);
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
