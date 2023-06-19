import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/modelo_repository.dart';

import '../model/modelo.dart';
import '../repository/marca_repository.dart';
import '../routes/app_routes.dart';

class ModeloTile extends StatelessWidget {
  final Modelo modelo;
  const ModeloTile(this.modelo);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: _obterModelo(),
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
                            .pushNamed(AppRoutes.modeloForm, arguments: modelo);
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
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Não'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Provider.of<ModeloRepository>(context, listen: false).removerModelo(modelo.idModelo!);
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
              ));});
  }

  Future<String?> _obterModelo() async {
    String? nomeModelo;
    String? ano;
    String? nomeMarca;

    final modeloDados = await ModeloRepository().byIndex(modelo.idModelo!);

    final marca = await MarcaRepository().byIndex(modelo!.idMarca!);

    nomeModelo = modelo!.nome!;
    ano = modelo!.ano!;
    nomeMarca = marca!.nome!;

    return nomeMarca + '/ ' + nomeModelo + '-' + ano;
  }
}