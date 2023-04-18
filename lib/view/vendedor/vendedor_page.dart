import 'package:flutter/material.dart';
import 'package:vendas_veiculos/model/vendedor.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/vendedor_repository.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';
import 'package:vendas_veiculos/widget/vendedor_row_builder.dart';

import '../../widget/bottom_navigation_widget.dart';

class VendedorPage extends StatefulWidget {
  const VendedorPage({Key? key}) : super(key: key);

  @override
  State<VendedorPage> createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  final VendedorRepository repository = VendedorRepository();
  List<Vendedor> vendedores = [];
  int numColumns = 2;

  @override
  Widget build(BuildContext context) {
    final vendedorRepository = context.watch<VendedorRepository>();
    vendedores = vendedorRepository.getVendedores();

    return Scaffold(
      appBar: AppBar(
        title: Text('Vendedores: (${vendedores.length})'),
        actions: [
          IconButton(
            onPressed: () =>
                setState(() => numColumns = (numColumns == 1) ? 2 : 1),
            icon: Icon(numColumns == 2
                ? Icons.view_agenda_outlined
                : Icons.grid_view_outlined),
          ),
        ],
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
                        "CPF",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  TableCell(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10)),
                      child: Container(
                        color: Colors.blueAccent,
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Nascimento",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...vendedores
                  .map((vendedor) =>
                      VendedorRowBuilder(vendedor: vendedor).build(context))
                  .toList()
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.vendedorForm);
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
