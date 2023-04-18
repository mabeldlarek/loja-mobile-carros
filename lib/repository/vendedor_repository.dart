import 'dart:collection';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';

import '../model/vendedor.dart';

class VendedorRepository extends ChangeNotifier {
  final List<Vendedor> _vendedores = [];
  
  UnmodifiableListView<Vendedor> get vendedores => UnmodifiableListView(_vendedores);

  VendedorRepository() {
    _vendedores.addAll([
      Vendedor(
          nome: "Nauder",
          cpf: "132.279.959-80",
          dataNascimento: "13/11/2002"
      ),
      Vendedor(
          nome: "Teste",
          cpf: UtilBrasilFields.gerarCPF(useFormat: true),
          dataNascimento: "13/11/1998"
      ),
      Vendedor(
          nome: "Vendedor",
          cpf: UtilBrasilFields.gerarCPF(useFormat: true),
          dataNascimento: "20/01/1969"
      ),
    ]);
    notifyListeners();
  }

  saveVendedor(Vendedor vendedor) {
    _vendedores.add(vendedor);
    notifyListeners();
  }

  deleteVendedor(Vendedor vendedor) {

    _vendedores.remove(vendedor);
    notifyListeners();
  }

  List<Vendedor> getVendedores() {
    return vendedores.toList();
  }

  updateVendedor(
      Vendedor vendedor,
      String nome,
      String cpf,
      String dataNascimento) {

    final vendedorIndex = findVendedorIndex(vendedor);

    _vendedores.replaceRange(vendedorIndex, vendedorIndex + 1, [
      Vendedor(
        nome: nome,
        cpf: cpf,
        dataNascimento: dataNascimento
      )
    ]);
    notifyListeners();
  }

  findVendedorIndex(Vendedor vendedor) {

    final vendedorOld = _vendedores.firstWhere((v) =>
      v.nome == vendedor.nome &&
      v.cpf == vendedor.cpf &&
      v.dataNascimento == vendedor.dataNascimento
    );

    return _vendedores.indexOf(vendedorOld);
  }
}