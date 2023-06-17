import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/cliente.dart';
import 'package:vendas_veiculos/model/venda.dart';
import 'package:vendas_veiculos/model/vendedor.dart';
import 'package:vendas_veiculos/repository/venda_repository.dart';
import '../repository/cliente_repository.dart';
import '../repository/promocao_repository.dart';
import '../repository/vendedor_repository.dart';

class CaixaPage extends StatefulWidget {
  @override
  _CaixaPageState createState() => _CaixaPageState();
}

class _CaixaPageState extends State<CaixaPage> {
  int? selectedClienteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Módulo Financeiro'),
      ),
      body: FutureBuilder<List<Venda>>(
        future: _obterVendas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as vendas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Não há vendas disponíveis'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final venda = snapshot.data![index];
                final cliente = venda.idCliente;
                final vendedor = VendedorRepository().obterVendedorPorId(venda.idVendedor);
                final veiculo = venda.idVeiculo;
                final valor = _calcularValorTotal(venda);

                return ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Venda ${venda.idVenda}'),
                  subtitle: Text('Cliente: $cliente | Vendedor: $vendedor'),
                  trailing: FutureBuilder<double>(
                    future: valor,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao calcular o valor');
                      } else {
                        final valorTotal = snapshot.data ?? 0;
                        return Text('R\$ $valorTotal');
                      }
                    },
                  ),
                  onTap: () {
                    generateReceipt(context, venda);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Venda>> _obterVendas() async {
    final vendas = await VendaRepository().getVendas();
    return vendas;
  }

  Future<double> _calcularValorTotal(Venda venda) async {
    double valorTotal = venda.entrada ?? 0;

    // Verifica se o veículo está em promoção
    final promocao = await PromocaoRepository().byVeiculo(venda.idVeiculo!);
    if (promocao != null) {
      valorTotal = promocao.valor;
    }

    // Realiza o cálculo da venda
    valorTotal -= venda.entrada ?? 0;
    valorTotal -= valorTotal * 0.05; // Desconto da comissão do vendedor (5%)

    return valorTotal;
  }

  void generateReceipt(BuildContext context, Venda venda) async {
    final vendedor = await VendedorRepository().obterVendedorPorId(venda.idVendedor);
    final cliente = await _obterCliente();
    final valor = _calcularValorTotal(venda);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recibo da Venda'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vendedor: ${vendedor?.nome ?? ''}'),
              Text('Cliente: ${cliente?.nome ?? ''}'),
              FutureBuilder<double>(
                future: valor,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro ao calcular o valor');
                  } else {
                    final valorTotal = snapshot.data ?? 0;
                    return Text('Valor Total: R\$ $valorTotal');
                  }
                },
              ),
              // Adicione mais informações do recibo conforme necessário
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<Cliente?> _obterCliente() async {
    final cliente = await Provider.of<ClienteRepository>(context, listen: false).byIndex(selectedClienteId ?? 0);
    return cliente;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteRepository()),
      ],
      child: MaterialApp(
        title: 'Vendas de Veículos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CaixaPage(),
      ),
    );
  }
}