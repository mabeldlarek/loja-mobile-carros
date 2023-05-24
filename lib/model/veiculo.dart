class Veiculo {
  final int? idVeiculo;
  final int? idModelo;
  final int? idFornecedor;
  final double valor;
  final String? tipo;
  final String? cor;
  final String? placa;

  const Veiculo({
    this.idVeiculo,
    required this.idModelo,
    required this.idFornecedor,
    required this.valor,
    required this.tipo,
    required this.cor,
    required this.placa,
    
  }
);

  Map<String, dynamic> toMap() {
    return {
      'idVeiculo': idVeiculo,
      'idModelo': idModelo,
    };
  }

  static Veiculo fromMap(Map<String, dynamic> map) {
    return Veiculo(
        idVeiculo: map['idVeiculo'],
        idModelo: map['idModelo'] ?? '',
        idFornecedor: map['idFornecedor'] ?? '',
        valor: map['valor'] ?? '',
        tipo: map['tipo'] ?? '',
        cor: map['cor'] ?? '',
        placa: map['placa'] ?? '');
  }

  String getDescricao() {
    return '';
  }
}
