import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/agenda.dart';

class AgendaTileSelecao extends StatelessWidget {
  final Agenda agenda;

  const AgendaTileSelecao(this.agenda);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('$agenda.titulo (${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(agenda.dataHora!))})'),
        onTap: () {
          final eventoSelecionado = agenda
              .idAgenda;
          Navigator.pop(context, eventoSelecionado);
        });
  }
}
