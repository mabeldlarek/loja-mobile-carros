class Agenda {
  final int? idAgenda;
  final int idVendedor;
  final String titulo;
  final String? descricao;
  final String dataHora;

  Agenda({
    this.idAgenda,
    required this.idVendedor,
    required this.titulo,
    this.descricao,
    required this.dataHora,
  });

  Map<String, dynamic> toMap() {
    return {
      'idAgenda': idAgenda,
      'idVendedor': idVendedor,
      'titulo': titulo,
      'descricao': descricao,
      'dataHora': dataHora,
    };
  }

  static Agenda fromMap(Map<String, dynamic> map) {
    return Agenda(
        idAgenda: map['idAgenda'],
        idVendedor: map['idVendedor'],
        titulo: map['titulo'],
        descricao: map['descricao'],
        dataHora: map['dataHora']);
  }
}
