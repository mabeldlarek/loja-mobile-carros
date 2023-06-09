import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/marca_repository.dart';

import '../model/marca.dart';
import '../routes/app_routes.dart';

class MarcaTile extends StatelessWidget {
 final Marca marca;
 const MarcaTile(this.marca);

  @override
  Widget build(BuildContext context) {
    final avatar = marca.imagem == null || marca.imagem!.isEmpty
        ? CircleAvatar(child: Icon(Icons.block_flipped))
        : CircleAvatar(backgroundImage: FileImage(File(marca.imagem!)));
    return ListTile(
        leading: avatar,
        title: Text(marca.nome!),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.marcaForm, arguments: marca);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Excluir Marca'),
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
                                  Provider.of<MarcaRepository>(context, listen: false)
                                      .removerMarca(marca.idMarca!);
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
