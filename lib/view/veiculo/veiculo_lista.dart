import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/components/veiculo_tile_selecao.dart';
import '../../components/veiculo_tile.dart';
import '../../model/veiculo.dart';
import '../../repository/veiculo_repository.dart';
import '../../routes/app_routes.dart';

class VeiculoList extends StatelessWidget {
  var contextPrevious = null;

  VeiculoList({super.key, BuildContext? ctxPrev}) {
    this.contextPrevious = ctxPrev;
  }

  @override
  Widget build(BuildContext context) {
    final VeiculoRepository veiculo = Provider.of(context);
    List<Veiculo> _veiculo = [];
    Future<List<Veiculo>> _list;
    _list = veiculo.getVeiculos();
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Veiculos'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.veiculoForm);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder<List<Veiculo>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (ctx, i) => contextPrevious == null? 
                  VeiculoTile(snapshot.data![i]) : VeiculoTileSelecao(snapshot.data![i])
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
