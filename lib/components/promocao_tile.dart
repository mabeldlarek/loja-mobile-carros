import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/promocao.dart';
import '../model/veiculo.dart';
import '../repository/promocao_repository.dart';
import '../repository/veiculo_repository.dart';
import '../routes/app_routes.dart';

class PromocaoTile extends StatelessWidget {
  final Promocao promocao;

  const PromocaoTile(this.promocao);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: _obterDescricao(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          String? resultado = snapshot.data;
          return ListTile(
              title: Text(resultado ?? ''),
              subtitle: null,
              trailing: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.promocaoForm,
                            arguments: promocao);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('Excluir Modelo'),
                                  content: Text('Tem certeza?'),
                                  actions: <Widget>[
                                    FloatingActionButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Não'),
                                    ),
                                    FloatingActionButton(
                                      onPressed: () {
                                        Provider.of<PromocaoRepository>(context,
                                                listen: false)
                                            .removerPromocao(
                                                promocao.idPromocao! as int);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sim'),
                                    )
                                  ],
                                ));
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<String?> _obterDescricao() async {
    return PromocaoRepository().obterDescricaoPromocao(promocao);
  }
}
