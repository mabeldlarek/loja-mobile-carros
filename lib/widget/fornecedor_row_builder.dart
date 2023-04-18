import 'package:flutter/material.dart';
import 'package:vendas_veiculos/model/fornecedor.dart';

import '../routes/app_routes.dart';

class FornecedorRowBuilder {
  final Fornecedor fornecedor;

  const FornecedorRowBuilder({Key? key, required this.fornecedor});

  _openDetails(BuildContext context) {
    Navigator.pushNamed(
        context,
        AppRoutes.fornecedorDetails,
        arguments: fornecedor,
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
                fornecedor.nome,
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
                fornecedor.cnpj,
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
