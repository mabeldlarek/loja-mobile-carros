
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/marca.dart';

import '../repository/marca_repository.dart';

class Modelo {
  final int? idModelo;
  final String? nome;
  final int? idMarca;
  final String? ano;
  final String? codigoFipe;
  final int? numPortas;
  final int? numAssentos;
  final double quilometragem;
  final String possuiAr;

  const Modelo({
    this.idModelo,
    required this.nome,
    required this.idMarca,
    required this.ano,
    required this.codigoFipe,
    required this.numPortas,
    required this.numAssentos,
    required this.quilometragem,
    required this.possuiAr,
  });

  Map<String, dynamic> toMap() {
    return {
      'idModelo': idModelo,
      'nome': nome,
      'idMarca': idMarca,
      'ano': ano,
      'codigoFipe': codigoFipe,
      'numPortas': numPortas,
      'numAssentos': numAssentos,
      'quilometragem': quilometragem,
      'possuiAr': possuiAr,
    };
  }

  static Modelo fromMap(Map<String, dynamic> map) {
    return Modelo(
      idModelo: map['idModelo'],
      nome: map['nome'],
      idMarca: (map['idMarca']),
      ano: map['ano'],
      codigoFipe: map['codigoFipe'],
      numPortas: map['numPortas'],
      numAssentos: map['numAssentos'],
      quilometragem: map['quilometragem'],
      possuiAr: map['possuiAr'],
    );
  }

  String get descricao{
    return '$nome- $ano';
  }
}
