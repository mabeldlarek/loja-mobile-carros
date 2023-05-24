import 'package:flutter/material.dart';
import 'package:vendas_veiculos/data/session.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';

class HomePageVendedor extends StatelessWidget {
  const HomePageVendedor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo, ${Session.nome}"),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.modeloList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Modelos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.clienteList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Relatórios",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.marcaList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Finanças",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(
                      Icons.branding_watermark,
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.clienteList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Clientes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(
                      Icons.merge_type,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
         ],
      ),
       bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Página Inicial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Minhas vendas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'Vender',
            ),
          ],
        ),
    );
  }
}
