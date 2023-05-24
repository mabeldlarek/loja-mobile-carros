
class Marca {
 final int? idMarca;
 final String? nome;
 final String? imagem;

  const Marca({
    this.idMarca,
    required this.nome,
    this.imagem,
  });

  Map<String, dynamic> toMap() {
    return {'idMarca': idMarca, 'nome': nome, 'imagem': imagem};
  }

  static Marca fromMap(Map<String, dynamic> map) {
  return Marca(idMarca: map['idMarca'], nome: map['nome'] ?? '', imagem: map['imagem']?? '');
  }
  
}
