import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/caixa.dart';
import 'package:vendas_veiculos/repository/caixa_repository.dart';

import '../../../components/caixa_tile.dart';
import '../../../routes/app_routes.dart';
import '../../model/venda.dart';

class CaixaList extends StatelessWidget {
  var contextPrevious = null;

  CaixaList({super.key, BuildContext? ctxPrev}) {
    this.contextPrevious = ctxPrev;
  }

  @override
  Widget build(BuildContext context) {
    final CaixaRepository caixa = Provider.of(context);
    caixa.database;
    List<Venda> _caixa = [];
    Future<List<Venda>> _list;
    _list = caixa.getVendas();
    return Scaffold(
        appBar: AppBar(
          title: Text('Módulo Financeiro'),
        ),
        body: FutureBuilder<List<Venda>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (ctx, i) => 
                        CaixaTile(snapshot.data![i])
          );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}