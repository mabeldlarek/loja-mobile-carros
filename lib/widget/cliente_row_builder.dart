import 'package:flutter/material.dart';

import '../model/cliente.dart';
import '../model/vendedor.dart';
import '../routes/app_routes.dart';

class ClienteRowBuilder {
  final Cliente cliente;

  const ClienteRowBuilder({Key? key, required this.cliente});

  _openDetails(BuildContext context) {
    Navigator.pushNamed(
        context,
        AppRoutes.clienteDetails,
        arguments: cliente,
    );
  }

  TableRow build(BuildContext context) {
    return TableRow(
      children: <Widget>[
        TableCell(
          child: TableRowInkWell(
            onTap: () => _openDetails(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                cliente.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        TableCell(
          child: TableRowInkWell(
            onTap: () => _openDetails(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                cliente.cpf,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        TableCell(
          child: TableRowInkWell(
            onTap: () => _openDetails(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                cliente.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        TableCell(
          child: TableRowInkWell(
            onTap: () => _openDetails(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                cliente.celular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
