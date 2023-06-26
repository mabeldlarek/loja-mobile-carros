import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/components/card_item.dart';
import 'package:vendas_veiculos/data/session.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';
import '../model/agenda.dart';
import '../repository/agenda_repository.dart';

class HomePageVendedor extends StatefulWidget {
  const HomePageVendedor({Key? key}) : super(key: key);

  @override
  _HomePageVendedorState createState() => _HomePageVendedorState();
}

class _HomePageVendedorState extends State<HomePageVendedor> {
  late AgendaRepository agenda;

  @override
  void initState() {
    super.initState();
    agenda = Provider.of<AgendaRepository>(context, listen: false);
  }

  void _atualizarAgenda() {
    setState(() {
      agenda = Provider.of<AgendaRepository>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo, ${Session.nome}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder<List<Agenda>>(
              key: ValueKey<String>('agenda_list'),
              future: agenda.getHomeEventos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }

                final eventos = snapshot.data;

                if (eventos == null || eventos.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não há eventos registrados'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.agendaForm);
                        },
                        child: Text('+ Adiconar novo evento'),
                      ),
                    ],
                  );
                }

                return Padding(
                    padding: EdgeInsets.all(15.0),
                    child: ListView.builder(
                      itemCount: eventos.length + 1,
                      itemBuilder: (context, index) {
                        if (index < eventos.length) {
                          final evento = eventos[index];
                          return ListTile(
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            dense: false,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.agendaForm,
                                  arguments: evento)
                                  .then((_) => _atualizarAgenda());
                            },
                            title: Text("${evento.titulo!}"),
                            trailing: Text(
                                "${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(evento.dataHora!))}"),
                            subtitle: Text(evento.descricao!.length > 25
                                ? "${evento.descricao!.substring(0, 25)}..."
                                : evento.descricao!),
                          );
                        } else if (index < 4) {
                          return ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.agendaList).then((_) => _atualizarAgenda());;
                            },
                            child: Text('VER MAIS'),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ));
              },
            ),
          ),
          GridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisCount: 2,
            shrinkWrap: true,
            children: <Widget>[
              CardItem(
                title: "Marcas",
                icon: Icons.branding_watermark,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.marcaList);
                },
              ),
              CardItem(
                title: "Modelos",
                icon: Icons.merge_type,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.modeloList);
                },
              ),
              CardItem(
                title: "Veículos",
                icon: Icons.car_crash,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.veiculoList);
                },
              ),
              CardItem(
                title: "Promoções",
                icon: Icons.local_offer,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.promocaoList);
                },
              ),
              CardItem(
                title: "Vendas",
                icon: Icons.branding_watermark,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.vendaList); //??
                },
              ),
              CardItem(
                title: "Clientes",
                icon: Icons.people,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.clienteList);
                },
              ),
            ],
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Página Inicial',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.monetization_on),
      //       label: 'Minhas vendas',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.app_registration),
      //       label: 'Vender',
      //     ),
      //   ],
      // ),
    );
  }
}