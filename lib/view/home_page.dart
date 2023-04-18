import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem vindo, Administrador"),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.vendedorList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Vendedores",
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
                      "Clientes",
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
                Navigator.pushNamed(context, AppRoutes.vendedorList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Marcas",
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
                Navigator.pushNamed(context, AppRoutes.vendedorList);
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
                      Icons.merge_type,
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
                Navigator.pushNamed(context, AppRoutes.vendedorList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Veículos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(
                      Icons.car_crash,
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
                Navigator.pushNamed(context, AppRoutes.fornecedorList);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Fornecedores",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(
                      Icons.warehouse,
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
