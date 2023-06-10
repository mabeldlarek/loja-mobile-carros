import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/marca.dart';

import '../repository/marca_repository.dart';

class Promocao {
  final int? idPromocao;
  final int? idVeiculo;
  final String? dataInicial;
  final String? dataFinal;
  final double valor; 

  const Promocao({
    this.idPromocao,
    required this.idVeiculo,
    required this.dataFinal,
    required this.dataInicial,
    required this.valor
  });

  Map<String, dynamic> toMap() {
    return {
      'idPromocao': idPromocao,
      'idVeiculo': idVeiculo,
      'dataInicial': dataInicial,
      'dataFinal': dataFinal,
      'valor': valor,
    };
  }

  static Promocao fromMap(Map<String, dynamic> map) {
    return Promocao(
      idPromocao: map['idPromocao'],
      idVeiculo: map['idVeiculo'],
      dataInicial: (map['dataInicial']),
      dataFinal: map['dataFinal'],
      valor: map['valor'],
    );
  }
}
