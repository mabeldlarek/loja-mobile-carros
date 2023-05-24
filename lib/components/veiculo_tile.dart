import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/veiculo_repository.dart';

import '../model/veiculo.dart';
import '../routes/app_routes.dart';

class VeiculoTile extends StatelessWidget {
  final Veiculo veiculo;

  const VeiculoTile(this.veiculo);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: _obterDescricao(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          String? resultado = snapshot.data;
          return ListTile(
              title: Text(resultado ?? ''),
              subtitle: null,
              trailing: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.veiculoForm, arguments: veiculo);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Excluir Modelo'),
                              content: Text('Tem certeza?'),
                              actions: <Widget>[
                                FloatingActionButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Não'),
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    Provider.of<VeiculoRepository>(context, listen: false)
                                        .removerVeiculo(veiculo.idVeiculo! as int);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Sim'),
                                )
                              ],
                            ));
                      },
                    )
                  ],
                ),
              ));});
  }

  Future<String?> _obterDescricao() async {
    return VeiculoRepository().obterDescricaoVeiculo(veiculo);
  }
}
