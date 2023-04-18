import 'package:flutter/material.dart';
import 'package:vendas_veiculos/model/fornecedor.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/fornecedor_repository.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';
import 'package:vendas_veiculos/widget/fornecedor_row_builder.dart';

import '../../widget/bottom_navigation_widget.dart';

class FornecedorPage extends StatefulWidget {
  const FornecedorPage({Key? key}) : super(key: key);

  @override
  State<FornecedorPage> createState() => _FornecedorPageState();
}

class _FornecedorPageState extends State<FornecedorPage> {
  final FornecedorRepository repository = FornecedorRepository();
  List<Fornecedor> fornecedores = [];

  @override
  Widget build(BuildContext context) {
    final fornecedorRepository = context.watch<FornecedorRepository>();
    fornecedores = fornecedorRepository.getFornecedores();

    return Scaffold(
      appBar: AppBar(
        title: Text('Fornecedores: (${fornecedores.length})'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Table(
            border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            defaultColumnWidth: const FlexColumnWidth(),
            children: [
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(10)),
                      child: Container(
                        color: Colors.blueAccent,
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Nome",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      color: Colors.blueAccent,
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                        "CNPJ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              ...fornecedores
                  .map((fornecedor) =>
                      FornecedorRowBuilder(fornecedor: fornecedor).build(context))
                  .toList()
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.fornecedorForm);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomNavigationWidget(
        buttons: [
          IconButton(
            tooltip: '',
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () => {},
          ),
          IconButton(
            tooltip: '',
            icon: const Icon(Icons.archive),
            onPressed: () => {},
          ),
          IconButton(
            tooltip: '',
            icon: const Icon(Icons.search),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
