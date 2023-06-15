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
      bool veiculoVendido = VendaRepository().byVeiculo(veiculo.idVeiculo!) ==  true? false : true;
        String? resultado = snapshot.data;
        return ListTile(
          enabled: veiculoVendido,
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
