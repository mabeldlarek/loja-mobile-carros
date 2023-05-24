import 'package:flutter/material.dart';
import '../model/veiculo.dart';
import '../repository/veiculo_repository.dart';

class VeiculoTileSelecao extends StatelessWidget {
  final Veiculo veiculo;

  const VeiculoTileSelecao(this.veiculo);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _obterDescricao(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String? resultado = snapshot.data;
          return ListTile(
            title: Text(resultado ?? 'Descrição não disponível'),
            onTap: () {
              final veiculoSelecionado = veiculo.idVeiculo;
              Navigator.pop(context, veiculoSelecionado);
            },
          );
        },
    );
  }

  Future<String?> _obterDescricao() async {
    return VeiculoRepository().obterDescricaoVeiculo(veiculo);
  }
}
