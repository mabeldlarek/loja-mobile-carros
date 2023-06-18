import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/caixa.dart';
import '../model/cliente.dart';
import '../model/veiculo.dart';
import '../model/venda.dart';
import '../repository/cliente_repository.dart';
import '../repository/promocao_repository.dart';
import '../repository/veiculo_repository.dart';
import '../repository/venda_repository.dart';
import '../repository/vendedor_repository.dart';
import '../routes/app_routes.dart';

class CaixaTile extends StatelessWidget {
  final Venda venda;
  const CaixaTile(this.venda);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _obterDescricao(venda),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String? resultado = snapshot.data;
        return ListTile(
          title: Text(resultado ?? ''),
          subtitle: null,
          trailing: Container(
              width: 100,
              child: Row(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.receipt),
                    onPressed: () {
                      generateReceipt(context, venda);
                    })
              ])),
        );
      },
    );
  }
}

Future<double> _calcularValorTotal(Venda venda) async {
  double valorTotal = 0;

  // Verifica se o veículo está em promoção
  final promocao = await PromocaoRepository().byIndex(venda.idVeiculo!);
  if (promocao != null) {
    final valorPromocao = promocao.valor;
    valorTotal = valorPromocao;
  }

  // Realiza o cálculo da venda
  valorTotal += venda.entrada ?? 0;
  valorTotal -= valorTotal * 0.05; // Desconto da comissão do vendedor (5%)

  return valorTotal;
}

void generateReceipt(BuildContext context, Venda venda) async {
  final vendedor =
      await VendedorRepository().obterVendedorPorId(venda.idVendedor);
  final cliente = await ClienteRepository().byIndex(venda.idCliente!);
  final valor = _calcularValorTotal(venda);

  Future<String?> _obterVeiculo(Venda venda) async {
    Veiculo? veiculo =
        await Provider.of<VeiculoRepository>(context, listen: false)
            .byIndex(venda.idVeiculo!);

    String? descricao =
        await Provider.of<VeiculoRepository>(context, listen: false)
            .obterDescricaoVeiculo(veiculo!);

    return descricao;
  }

  String formatarData(data){
      DateTime dataFormatada = DateFormat('yyyy-MM-dd').parse(venda.data!);
      String data = DateFormat('dd/MM/yyyy').format(dataFormatada);

      return data;
  }

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Recibo da Venda'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Data: ${formatarData(venda.data) ?? ''}'),            Text('Vendedor: ${vendedor?.nome ?? ''}'),
            Text('Cliente: ${cliente?.nome ?? ''}'),
            FutureBuilder<String?>(
              future: _obterVeiculo(venda),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao obter veículo');
                } else {
                  final descricao = snapshot.data ?? 0;
                  return Text('Veículo: R\$ $descricao');
                }
              },
            ),
            FutureBuilder<double>(
              future: _calcularValorTotal(venda),
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

Future<String?> _obterDescricao(Venda venda) async {
  return VendaRepository().obterDescricaoVenda(venda);
}
