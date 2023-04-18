import 'package:flutter/material.dart';

import '../model/vendedor.dart';
import '../routes/app_routes.dart';

class VendedorRowBuilder {
  final Vendedor vendedor;

  const VendedorRowBuilder({Key? key, required this.vendedor});

  _openDetails(BuildContext context) {
    Navigator.pushNamed(
        context,
        AppRoutes.vendedorDetails,
        arguments: vendedor,
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
                vendedor.nome,
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
                vendedor.cpf,
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
                vendedor.dataNascimento,
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
