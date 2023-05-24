import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/components/cliente_tile_selecao.dart';
import '../../components/cliente_tile.dart';
import '../../model/cliente.dart';
import '../../repository/cliente_repository.dart';
import '../../routes/app_routes.dart';

class ClienteList extends StatelessWidget {
  var contextPrevious = null;
  bool? _somenteFornecedor = false;

  ClienteList({super.key, BuildContext? ctxPrev, bool? somenteFornecedor}) {
    this.contextPrevious = ctxPrev;
    this._somenteFornecedor = somenteFornecedor;
  }

  @override
  Widget build(BuildContext context) {
    final ClienteRepository cliente = Provider.of(context);
    List<Cliente> _cliente = [];
    Future<List<Cliente>> _list;

    _list = _somenteFornecedor == true ? cliente.getClientesFornecedores() : cliente.getClientes();

    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Clientes'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.clienteForm);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder<List<Cliente>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (ctx, i) => contextPrevious == null? 
                  ClienteTile(snapshot.data![i]) : ClienteTileSelecao(snapshot.data![i])
                );
              } else {
                return CircularProgressIndicator(); // or any other loading indicator
              }
            }));
  }
}
