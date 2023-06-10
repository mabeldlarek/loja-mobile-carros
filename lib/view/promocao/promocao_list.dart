import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/promocao.dart';
import 'package:vendas_veiculos/repository/promocao_repository.dart';

import '../../components/promocao_tile.dart';
import '../../routes/app_routes.dart';

class PromocaoList extends StatelessWidget {
  var contextPrevious = null;

  PromocaoList({super.key, BuildContext? ctxPrev}) {
    this.contextPrevious = ctxPrev;
  }

  @override
  Widget build(BuildContext context) {
    final PromocaoRepository promocao = Provider.of(context);
    promocao.database;
    List<Promocao> _promocao = [];
    Future<List<Promocao>> _list;
    _list = promocao.getPromocaos();
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Promocaos'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.promocaoForm);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder<List<Promocao>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (ctx, i) => PromocaoTile(snapshot.data![i])
                        );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
