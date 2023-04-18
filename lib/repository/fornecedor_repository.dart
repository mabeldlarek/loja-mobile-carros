import 'dart:collection';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';

import '../model/fornecedor.dart';

class FornecedorRepository extends ChangeNotifier {
  final List<Fornecedor> _fornecedores = [];

  UnmodifiableListView<Fornecedor> get fornecedores =>
      UnmodifiableListView(_fornecedores);

  FornecedorRepository() {
    _fornecedores.addAll([
      Fornecedor(
          nome: "Nauder", cnpj: UtilBrasilFields.gerarCNPJ(useFormat: true)),
      Fornecedor(
          nome: "Teste", cnpj: UtilBrasilFields.gerarCNPJ(useFormat: true)),
      Fornecedor(
          nome: "Fornecedor 3",
          cnpj: UtilBrasilFields.gerarCNPJ(useFormat: true)),
    ]);
    notifyListeners();
  }

  saveFornecedor(Fornecedor fornecedor) {
    _fornecedores.add(fornecedor);
    notifyListeners();
  }

  deleteFornecedor(Fornecedor fornecedor) {
    _fornecedores.remove(fornecedor);
    notifyListeners();
  }

  List<Fornecedor> getFornecedores() {
    return fornecedores.toList();
  }

  updateFornecedor(Fornecedor fornecedor, String nome, String cnpj) {
    final fornecedorIndex = findFornecedorIndex(fornecedor);

    _fornecedores.replaceRange(fornecedorIndex, fornecedorIndex + 1,
        [Fornecedor(nome: nome, cnpj: cnpj)]);
    notifyListeners();
  }

  findFornecedorIndex(Fornecedor fornecedor) {
    final fornecedorOld = _fornecedores.firstWhere(
        (f) => f.nome == fornecedor.nome && f.cnpj == fornecedor.cnpj);

    return _fornecedores.indexOf(fornecedorOld);
  }
}
