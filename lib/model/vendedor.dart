class Vendedor {
  final int? idVendedor;
  final String nome;
  final String cpf;
  final String dataNascimento;
  final String email;
  final String senha;
  final bool ativo;

  Vendedor({
    this.idVendedor,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.email,
    required this.senha,
    this.ativo = true
  });

  Map<String, dynamic> toMap() {
    return {
      'idVendedor': idVendedor,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'email': email,
      'senha': senha,
    };
  }

  static Vendedor fromMap(Map<String, dynamic> map) {
    return Vendedor(
      idVendedor: map['idVendedor'],
      nome: map['nome'],
      cpf: map['cpf'],
      dataNascimento: map['dataNascimento'],
      email: map['email'],
      senha: map['senha'],
    );
  }
}