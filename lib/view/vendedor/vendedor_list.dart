import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/vendedor_tile.dart';
import '../../model/venda.dart';
import '../../model/vendedor.dart';
import '../../repository/venda_repository.dart';
import '../../repository/vendedor_repository.dart';
import '../../routes/app_routes.dart';

class VendedorList extends StatelessWidget {
  const VendedorList({super.key});

  @override
  Widget build(BuildContext context) {
    final VendedorRepository vendas = Provider.of(context);
    //final dbHelper = DatabaseHelper.instance;
    List<Vendedor> _vendas = [];
    Future<List<Vendedor>> _list;
    _list = vendas.getVendedors();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Vendedores'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.vendedorForm);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder<List<Vendedor>>(
  future: _list,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data?.length,
        itemBuilder: (ctx, i) => VendedorTile(snapshot.data![i]),
      );
    } else {
      return CircularProgressIndicator(); // or any other loading indicator
    }
  }
  ));
}
}
