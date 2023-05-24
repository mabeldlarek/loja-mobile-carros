import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/cliente.dart';
import '../model/modelo.dart';

class ClienteTileSelecao extends StatelessWidget {
  final Cliente cliente;

  const ClienteTileSelecao(this.cliente);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(cliente.nome),
        onTap: () {
          final clienteSelecionado = cliente
              .idCliente;
          Navigator.pop(context, clienteSelecionado);
        });
  }
}
