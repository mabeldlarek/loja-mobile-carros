import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/components/modelo_tile_selecao.dart';
import 'package:vendas_veiculos/model/modelo.dart';
import 'package:vendas_veiculos/repository/modelo_repository.dart';

import '../../components/modelo_tile.dart';
import '../../routes/app_routes.dart';

class ModeloList extends StatelessWidget {
  var contextPrevious = null;

  ModeloList({super.key, BuildContext? ctxPrev}) {
    this.contextPrevious = ctxPrev;
  }

  @override
  Widget build(BuildContext context) {
    final ModeloRepository modelo = Provider.of(context);
    modelo.database;
    List<Modelo> _modelo = [];
    Future<List<Modelo>> _list;
    _list = modelo.getModelos();
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Modelos'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.modeloForm);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder<List<Modelo>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (ctx, i) => contextPrevious == null
                        ? ModeloTile(snapshot.data![i])
                        : ModeloTileSelecao(snapshot.data![i]));
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
