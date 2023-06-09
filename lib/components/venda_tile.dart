import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/venda_repository.dart';

import '../model/venda.dart';
import '../repository/veiculo_repository.dart';
import '../routes/app_routes.dart';

class VendaTile extends StatelessWidget {
 final Venda venda;
 const VendaTile(this.venda);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String?>(
        future: _obterDescricao(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String? resultado = snapshot.data;
        return ListTile(
            title: Text(resultado ?? ""),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.vendaForm, arguments: venda);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Excluir Venda'),
                                content: Text('Tem certeza?'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Não'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<VendaRepository>(context, listen: false)
                                          .removerVenda(venda.idVenda!);
                                      print('apagou');
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text('Sim, excluir'),
                                      )
                                  ],
                                ));
                          },
                        )
                      ],
                    ),
                  ));});
  }

  Future<String?> _obterDescricao() async {
    return VendaRepository().obterDescricaoVenda(venda);
  }

}
