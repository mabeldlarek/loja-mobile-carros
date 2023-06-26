import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/data/session.dart';
import 'package:vendas_veiculos/model/caixa.dart';
import 'package:vendas_veiculos/repository/caixa_repository.dart';
import 'package:vendas_veiculos/view/caixa/caixa_list.dart';
import 'package:vendas_veiculos/repository/agenda_repository.dart';
import 'package:vendas_veiculos/repository/cliente_repository.dart';
import 'package:vendas_veiculos/repository/marca_repository.dart';
import 'package:vendas_veiculos/repository/modelo_repository.dart';
import 'package:vendas_veiculos/repository/promocao_repository.dart';
import 'package:vendas_veiculos/repository/veiculo_repository.dart';
import 'package:vendas_veiculos/repository/venda_repository.dart';
import 'package:vendas_veiculos/repository/vendedor_repository.dart';
import 'package:vendas_veiculos/routes/app_routes.dart';
import 'package:vendas_veiculos/view/agenda/agenda_form.dart';
import 'package:vendas_veiculos/view/agenda/agenda_list.dart';
import 'package:vendas_veiculos/view/cliente/cliente_form.dart';
import 'package:vendas_veiculos/view/cliente/cliente_list.dart';
import 'package:vendas_veiculos/view/home_page_administrador.dart';
import 'package:vendas_veiculos/view/home_page_vendedor.dart';
import 'package:vendas_veiculos/view/login_page.dart';
import 'package:vendas_veiculos/view/marca/marca_form.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/view/modelo/modelo_form.dart';
import 'package:vendas_veiculos/view/modelo/modelo_list.dart';
import 'package:vendas_veiculos/view/promocao/promocao_form.dart';
import 'package:vendas_veiculos/view/promocao/promocao_list.dart';
import 'package:vendas_veiculos/view/veiculo/veiculo_form.dart';
import 'package:vendas_veiculos/view/veiculo/veiculo_list.dart';
import 'package:vendas_veiculos/view/venda/venda_form.dart';
import 'package:vendas_veiculos/view/venda/venda_list.dart';
import 'package:vendas_veiculos/view/vendedor/vendedor_form.dart';
import 'package:vendas_veiculos/view/vendedor/vendedor_list.dart';
import 'view/marca/marca_list.dart';
 
Future<void>main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await VendedorRepository().seed();

  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor appColor = MaterialColor(0xFF004E86, {
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    }); // Azul logo

    return MultiProvider(
      providers: [
        //usa multiplos providers
        ChangeNotifierProvider(
          //Marcas implementa o observer
          create: (ctx) => MarcaRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => VendedorRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ClienteRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ModeloRepository(),
        ),
         ChangeNotifierProvider(
          create: (ctx) => VeiculoRepository(),
        ),
         ChangeNotifierProvider(
          create: (ctx) => VendaRepository(),
        ),
         ChangeNotifierProvider(
          create: (ctx) => VendedorRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PromocaoRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AgendaRepository(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CaixaRepository(),
        ),
      ],
      child: MaterialApp(
        supportedLocales: [
          const Locale('pt', 'BR'),
        ],
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'OffRoad',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: appColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: appColor,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.vendedorHome: (_) => const HomePageVendedor(),
          AppRoutes.administradorHome: (_) => const HomePageAdministrador(),
          AppRoutes.marcaForm:  (_) => MarcaForm(),
          AppRoutes.marcaList:  (_) => MarcaList(),
          AppRoutes.modeloForm: (_) => ModeloForm(),
          AppRoutes.modeloList: (_) => ModeloList(),
          AppRoutes.veiculoForm: (_) => VeiculoForm(),
          AppRoutes.veiculoList: (_) => VeiculoList(),
          AppRoutes.clienteForm: (_) => ClienteForm(),
          AppRoutes.clienteList: (_) => ClienteList(),
          AppRoutes.vendaForm: (_) => VendaForm(),
          AppRoutes.vendaList: (_) => VendaList(),
          AppRoutes.vendedorForm: (_) => VendedorForm(),
          AppRoutes.vendedorList: (_) => VendedorList(),
          AppRoutes.promocaoForm: (_) => PromocaoForm(),
          AppRoutes.promocaoList: (_) => PromocaoList(),
          AppRoutes.caixa: (_) => CaixaList(),
          AppRoutes.agendaForm: (_) => AgendaForm(),
          AppRoutes.agendaList: (_) => AgendaList(),
        },
      ),
    );
  }
}
