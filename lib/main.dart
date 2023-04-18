import 'package:flutter/material.dart';
import 'package:vendas_veiculos/model/cliente.dart';
import 'package:vendas_veiculos/model/fornecedor.dart';
import 'package:vendas_veiculos/provider/marcas.dart';
import 'package:vendas_veiculos/repository/cliente_repository.dart';
import 'package:vendas_veiculos/repository/fornecedor_repository.dart';
import 'package:vendas_veiculos/repository/vendedor_repository.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';
import 'package:vendas_veiculos/view/cliente/add_cliente_page.dart';
import 'package:vendas_veiculos/view/cliente/cliente_details_page.dart';
import 'package:vendas_veiculos/view/cliente/cliente_page.dart';
import 'package:vendas_veiculos/view/fornecedor/add_fornecedor_page.dart';
import 'package:vendas_veiculos/view/fornecedor/fornecedor_details_page.dart';
import 'package:vendas_veiculos/view/fornecedor/fornecedor_page.dart';
import 'package:vendas_veiculos/view/home_page.dart';
import 'package:vendas_veiculos/view/marca/marca_form.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/view/vendedor/add_vendedor_page.dart';
import 'package:vendas_veiculos/view/vendedor/vendedor_details_page.dart';
import 'package:vendas_veiculos/view/vendedor/vendedor_page.dart';

import 'model/vendedor.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //usa multiplos providers
        ChangeNotifierProvider(
          //Marcas implementa o observer
          create: (ctx) => Marcas(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => VendedorRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ClienteRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FornecedorRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Car Store App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.vendedorDetails) {
            return MaterialPageRoute(
              builder: (context) {
                return VendedorDetailsPage(
                    vendedor: settings.arguments as Vendedor);
              },
            );
          } else if (settings.name == AppRoutes.clienteDetails) {
            return MaterialPageRoute(
              builder: (context) {
                return ClienteDetailsPage(
                    cliente: settings.arguments as Cliente);
              },
            );
          } else if (settings.name == AppRoutes.fornecedorDetails) {
            return MaterialPageRoute(
              builder: (context) {
                return FornecedorDetailsPage(
                    fornecedor: settings.arguments as Fornecedor);
              },
            );
          }
          assert(false, 'Implementation ${settings.name}');
          return null;
        },
        routes: {
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.marcaForm: (_) => MarcaForm(),
          AppRoutes.vendedorList: (_) => const VendedorPage(),
          AppRoutes.vendedorForm: (_) => const AddVendedorPage(),
          AppRoutes.clienteList: (_) => const ClientePage(),
          AppRoutes.clienteForm: (_) => const AddClientePage(),
          AppRoutes.fornecedorList: (_) => const FornecedorPage(),
          AppRoutes.fornecedorForm: (_) => const AddFornecedorPage(),
        },
      ),
    );
  }
}
