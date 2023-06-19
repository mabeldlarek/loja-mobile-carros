import 'dart:ffi';

import 'package:flutter/material.dart';
import '../model/veiculo.dart';
import '../repository/promocao_repository.dart';
import '../repository/veiculo_repository.dart';
import '../repository/venda_repository.dart';

class VeiculoTileSelecao extends StatelessWidget {
  final Veiculo veiculo;

  const VeiculoTileSelecao(this.veiculo);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _obterDescricao(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
      return FutureBuilder<bool?>(
        future: VendaRepository().byVeiculo(veiculo.idVeiculo!),
        builder: (BuildContext context, AsyncSnapshot<bool?> vendaSnapshot) {
          String? resultado = snapshot.data;
          bool veiculoVendido = vendaSnapshot.data ?? false; 
          return ListTile(
            enabled: !veiculoVendido, 
            title: Text(resultado ?? 'Descrição não disponível'),
            onTap: () {
              final veiculoSelecionado = veiculo.idVeiculo;
              Navigator.pop(context, veiculoSelecionado);
            },
          );
        },
      );
    },
  );
}

  Future<String?> _obterDescricao() async {
    return VeiculoRepository().obterDescricaoVeiculo(veiculo);
  }

}
