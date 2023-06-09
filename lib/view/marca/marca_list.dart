import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/marcas_tile.dart';
import '../../model/marca.dart';
import '../../repository/marca_repository.dart';
import '../../routes/app_routes.dart';

class MarcaList extends StatelessWidget {
  const MarcaList({super.key});

  @override
  Widget build(BuildContext context) {
    final MarcaRepository marcas = Provider.of(context);
    //final dbHelper = DatabaseHelper.instance;
    List<Marca> _marcas = [];
    Future<List<Marca>> _list;
    _list = marcas.getMarcas();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Marcas'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.marcaForm);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder<List<Marca>>(
  future: _list,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data?.length,
        itemBuilder: (ctx, i) => MarcaTile(snapshot.data![i]),
      );
    } else {
      return CircularProgressIndicator(); // or any other loading indicator
    }
  }
  ));
}
}
