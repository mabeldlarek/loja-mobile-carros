import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/marca.dart';
import '../provider/marcas.dart';
import '../routes/app_routes.dart';

class MarcaTile extends StatelessWidget {
  final Marca marca;
  const MarcaTile(this.marca, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = marca.imageUrl == null || marca.imageUrl!.isEmpty
        ? const CircleAvatar(child: Icon(Icons.block_flipped))
        : CircleAvatar(backgroundImage: NetworkImage(marca.imageUrl!));
    return ListTile(
        leading: avatar,
        title: Text(marca.nome!),
        subtitle: null,
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.marcaForm, arguments: marca);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text('Excluir Marca'),
                            content: const Text('Tem certeza?'),
                            actions: <Widget>[
                              FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Não'),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  Provider.of<Marcas>(context, listen: false)
                                      .remove(marca);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Sim'),
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
