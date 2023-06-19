import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/veiculo_repository.dart';
import 'package:vendas_veiculos/repository/venda_repository.dart';

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
          return FutureBuilder<bool?>(
              future: VendaRepository().byVeiculo(veiculo.idVeiculo!),
              builder:
                  (BuildContext context, AsyncSnapshot<bool?> vendaSnapshot) {
                String? resultado = snapshot.data;
                bool veiculoVendido = vendaSnapshot.data ?? false;
                return ListTile(
                    enabled: veiculoVendido,
                    title: Text(resultado ?? ''),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.orange,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.veiculoForm,
                                  arguments: veiculo);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Excluir Veículo'),
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
                                              Provider.of<VeiculoRepository>(
                                                      context,
                                                      listen: false)
                                                  .removerVeiculo(veiculo
                                                      .idVeiculo! as int);
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
              });
        });
  }

  Future<String?> _obterDescricao() async {
    return VeiculoRepository().obterDescricaoVeiculo(veiculo);
  }
}
