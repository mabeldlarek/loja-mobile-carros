import 'dart:collection';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';

import '../model/cliente.dart';

class ClienteRepository extends ChangeNotifier {
  final List<Cliente> _clientes = [];
  
  UnmodifiableListView<Cliente> get clientes => UnmodifiableListView(_clientes);

  ClienteRepository() {
    _clientes.addAll([
      Cliente(
        nome: "Nauder",
        cpf: "132.279.959-80",
        email: "mail@exemplo.com",
        celular: "42998317285"
      ),
      Cliente(
          nome: "Teste",
          cpf: UtilBrasilFields.gerarCPF(useFormat: true),
          email: "mail@exemplo.com",
          celular: "42998317285"
      ),
      Cliente(
          nome: "Cliente",
          cpf: UtilBrasilFields.gerarCPF(useFormat: true),
          email: "mail@exemplo.com",
          celular: "42998317285"
      ),
    ]);
    notifyListeners();
  }

  saveCliente(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners();
  }

  deleteCliente(Cliente cliente) {

    _clientes.remove(cliente);
    notifyListeners();
  }

  List<Cliente> getClientes() {
    return clientes.toList();
  }

  updateCliente(
      Cliente cliente,
      String nome,
      String cpf,
      String email,
      String celular) {

    final clienteIndex = findClienteIndex(cliente);

    _clientes.replaceRange(clienteIndex, clienteIndex + 1, [
      Cliente(
        nome: nome,
        cpf: cpf,
        email: email,
        celular: celular
      )
    ]);
    notifyListeners();
  }

  findClienteIndex(Cliente cliente) {

    final clienteOld = _clientes.firstWhere((c) =>
      c.nome == cliente.nome && c.cpf == cliente.cpf &&
      c.email == cliente.email && c.celular == cliente.celular
    );

    return _clientes.indexOf(clienteOld);
  }
}