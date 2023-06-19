import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/cliente_repository.dart';

import '../model/cliente.dart';
import '../routes/app_routes.dart';

class ClienteTile extends StatelessWidget {
 final Cliente cliente;
 const ClienteTile(this.cliente);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(cliente.nome!),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.clienteForm, arguments: cliente);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Excluir Cliente'),
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
                                  Provider.of<ClienteRepository>(context, listen: false)
                                      .removerCliente(cliente.idCliente!);
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
