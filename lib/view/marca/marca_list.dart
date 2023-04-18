import 'package:flutter/material.dart';
import 'package:vendas_veiculos/provider/marcas.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../components/marcas_tile.dart';

class MarcaList extends StatelessWidget {
  const MarcaList({super.key});

  @override
  Widget build(BuildContext context) {
    final Marcas marcas = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Marcas'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.marcaForm);
                  //marcas.put(Marca(id: '2', nome: 'Ju', imageUrl: ''));
                  //marcas.remove(marcas.byIndex(0));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: ListView.builder(
          itemCount: marcas.count,
          itemBuilder: (ctx, i) => MarcaTile(marcas.byIndex(i)),
        ));
  }
}
