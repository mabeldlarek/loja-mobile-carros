class Vendedor {
  final String nome;
  final String cpf;
  final String dataNascimento;
  final bool ativo;

  Vendedor({
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    this.ativo = true
  });
}