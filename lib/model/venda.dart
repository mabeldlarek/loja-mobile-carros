class Venda {
  final int? idVenda;
  final int? idVeiculo;
  final int? idCliente;
  final int? idVendedor;
  final double entrada;
  final int? parcelas;
  final String? data;

  const Venda({
    this.idVenda,
    required this.idVeiculo,
    required this.idCliente,
    required this.idVendedor,
    required this.entrada,
    required this.parcelas,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'idVenda': idVenda,
      'idVeiculo': idVeiculo,
      'idCliente': idCliente,
      'idVendedor': idVendedor,
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
      idVendedor: map['idVendedor'],
      entrada: map['entrada'],
      parcelas: map['parcelas'],
      data: map['data'],
    );
  }
}
