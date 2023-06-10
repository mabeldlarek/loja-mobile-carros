import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RealCurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formattedValue = formatarValor(newValue);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String formatarValor(newValue) {
    final numericValue =
        int.parse(newValue.text.replaceAll(RegExp(r'[^0-9]'), ''));
    final formattedValue = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(numericValue / 100);
    return formattedValue;
  }

  String formatCurrency(double value) {
    NumberFormat formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    String valorFormatado = formatadorMoeda.format(value);
    return valorFormatado;
  }

}
