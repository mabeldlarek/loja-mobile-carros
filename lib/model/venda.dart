class Venda {
  final int? idVenda;
  final int? idVeiculo;
  final int? idCliente;
  final String? entrada;
  final int? parcelas;
  final String? data;

  const Venda({
    this.idVenda,
    required this.idVeiculo,
    required this.idCliente,
    required this.entrada,
    required this.parcelas,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'idVenda': idVenda,
      'veiculo_id': idVeiculo,
      'cliente_id': idCliente,
      'entrada': entrada,
      'parcelas': parcelas,
      'data': data,
    };
  }

  static Venda fromMap(Map<String, dynamic> map) {
    return Venda(
      idVenda: map['idVenda'],
      idVeiculo: map['idVeiculo'],
      idCliente: map['idCliente'],
      entrada: map['entrada'].toString(),
      parcelas: map['parcelas'],
      data: map['data'],
    );
  }
}
