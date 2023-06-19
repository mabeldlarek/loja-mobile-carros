import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/vendedor_repository.dart';

import '../model/vendedor.dart';
import '../routes/app_routes.dart';

class VendedorTile extends StatelessWidget {
 final Vendedor vendedor;
 const VendedorTile(this.vendedor);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(vendedor.nome!),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.vendedorForm, arguments: vendedor);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Excluir Vendedor'),
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
                                  Provider.of<VendedorRepository>(context, listen: false)
                                      .removerVendedor(vendedor.idVendedor!);
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
