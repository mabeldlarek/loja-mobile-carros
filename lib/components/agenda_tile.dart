import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:vendas_veiculos/repository/agenda_repository.dart';
import '../model/agenda.dart';
import '../routes/app_routes.dart';

class AgendaTile extends StatelessWidget {
 final Agenda agenda;
 const AgendaTile(this.agenda);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('${agenda.titulo} (${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(agenda.dataHora!))})'),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.agendaForm, arguments: agenda);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Excluir Evento'),
                            content: Text('Tem certeza?'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Não'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<AgendaRepository>(context, listen: false)
                                      .removerAgenda(agenda.idAgenda!);
                                  print('apagou');
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text('Sim, excluir'),
                              )
                            ],
                          ));
                },
              )
            ],
          ),
        ));
  }
}
