import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/venda.dart';
import 'package:vendas_veiculos/repository/venda_repository.dart';

import '../../components/venda_tile.dart';
import '../../routes/app_routes.dart';

class VendaList extends StatelessWidget {
  var contextPrevious = null;

  VendaList({super.key, BuildContext? ctxPrev}) {
    this.contextPrevious = ctxPrev;
  }

  @override
  Widget build(BuildContext context) {
    final VendaRepository venda = Provider.of(context);
    venda.database;
    List<Venda> _venda = [];
    Future<List<Venda>> _list;
    _list = venda.getVendas();
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Vendas'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.vendaForm);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder<List<Venda>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (ctx, i) => VendaTile(snapshot.data![i])
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
