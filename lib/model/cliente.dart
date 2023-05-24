class Cliente {
  final int? idCliente;
  final String nome;
  final String cpf;
  final String? cnpj;
  final String email;
  final String celular;
  final String dataNascimento;
  final String tipo;

  Cliente({
    this.idCliente,
    required this.nome,
    required this.cpf,
    this.cnpj,
    required this.email,
    required this.celular,
    required this.dataNascimento,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'nome': nome,
      'cpf': cpf,
      'cnpj': cnpj,
      'email': email,
      'celular': celular,
      'dataNascimento': dataNascimento,
      'tipo': tipo,
    };
  }

  static Cliente fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['idCliente'],
      nome: map['nome'],
      cpf: map['cpf'],
      cnpj: map['cnpj'],
      email: map['email'],
      celular: map['celular'],
      dataNascimento: map['dataNascimento'],
      tipo: map['tipo'],
  );
}
}
