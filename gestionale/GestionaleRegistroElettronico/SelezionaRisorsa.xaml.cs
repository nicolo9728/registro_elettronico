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
    /// Logica di interazione per SelezionaRisorsa.xaml
    /// </summary>
    public partial class SelezionaRisorsa : Window
    {
        public Object ElementoSelezionato { get; private set; }
        public SelezionaRisorsa(IEnumerable<Object> elementi)
        {
            InitializeComponent();
            DataContext = elementi;
            lblTipo.Text = elementi.First().GetType().Name;
        }

        private void Seleziona(object sender, RoutedEventArgs e)
        {
            ElementoSelezionato = lbxClassi.SelectedItem;
            DialogResult = true;
            Close();
        }
    }
}
