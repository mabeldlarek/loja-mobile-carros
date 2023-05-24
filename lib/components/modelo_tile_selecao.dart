import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/modelo.dart';
import '../repository/marca_repository.dart';
import '../repository/modelo_repository.dart';

class ModeloTileSelecao extends StatelessWidget {
  final Modelo modelo;

  const ModeloTileSelecao(this.modelo);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: _obterModelo(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          String? resultado = snapshot.data;
          return ListTile(
              title: Text(resultado ?? ''),
              onTap: () {
                final veiculoSelecionado = modelo.idModelo;
                Navigator.pop(context, veiculoSelecionado);
              });});
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
