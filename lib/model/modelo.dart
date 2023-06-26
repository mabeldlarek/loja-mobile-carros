class Modelo {
  final int? idModelo;
  final String? nome;
  final int? idMarca;
  final String? ano;
  final String? codigoFipe;
  final int? numeroPortas;
  final int? numeroAssentos;
  final double quilometragem;
  final String possuiAr;

  const Modelo({
    this.idModelo,
    required this.nome,
    required this.idMarca,
    required this.ano,
    required this.codigoFipe,
    required this.numeroPortas,
    required this.numeroAssentos,
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
      'numeroPortas': numeroPortas,
      'numeroAssentos': numeroAssentos,
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
      numeroPortas: map['numeroPortas'],
      numeroAssentos: map['numeroAssentos'],
      quilometragem: map['quilometragem'],
      possuiAr: map['possuiAr'],
    );
  }

  String get descricao{
    return '$nome- $ano';
  }
}
