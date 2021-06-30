using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace GestionaleRegistroElettronico.controlli
{
    class ControlloNumero : ValidationRule
    {
        public override ValidationResult Validate(object value, CultureInfo cultureInfo)
        {
            int risultato;
            if (int.TryParse((string)value, out risultato))
                return ValidationResult.ValidResult;
            else
                return new ValidationResult(false, "Numero non valido");
        }
    }
}
