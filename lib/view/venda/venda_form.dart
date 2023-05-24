import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/cliente.dart';
import '../../model/veiculo.dart';
import '../../model/venda.dart';
import '../../repository/cliente_repository.dart';
import '../../repository/veiculo_repository.dart';
import '../../repository/venda_repository.dart';
import '../cliente/cliente_list.dart';
import '../veiculo/veiculo_lista.dart';

class VendaForm extends StatefulWidget {
  @override
  State<VendaForm> createState() => _VendaFormState();
}


class _VendaFormState extends State<VendaForm> {
  final _form = GlobalKey<FormState>();
  // associar com o formulário e acessar ele
  final Map<String, String> _formData = {};
  var selectedVeiculoId = null;
  var selectedClienteId = null;
  TextEditingController _controllerVeiculo = new TextEditingController();
  TextEditingController _controllerCliente = new TextEditingController();
  TextEditingController _controllerEntrada = new TextEditingController();


  @override
  void dispose() {
    _controllerEntrada.dispose();
    super.dispose();
  }

  String dropdownvalue = '';
  var valorVeiculo = 0.0;
  String valorEntrada = "";
  int? _id;
  List<String> parcelas = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
  ];

  void preencherControllers(venda) async {
    if (venda != null) {
      final veiculo = await VeiculoRepository().byIndex(venda.idVeiculo);
      final veiculoDescricao =
          await VeiculoRepository().obterDescricaoVeiculo(veiculo!);
      final cliente = await ClienteRepository().byIndex(venda.idCliente);
      _controllerVeiculo.text = veiculoDescricao!;
      _controllerCliente.text = cliente!.nome!;
    }
  }

  void _loadFormData(Venda? venda) {
    if (venda != null) {
      _id = venda.idVenda;
      selectedVeiculoId = venda.idVeiculo;
      selectedClienteId = venda.idCliente;
      _formData['entrada'] = venda.entrada!;
      _formData['parcela'] = venda.parcelas!.toString();
      valorEntrada = venda.entrada!;
      _controllerEntrada.text = valorEntrada;
      _obterValorVeiculo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Venda? venda = ModalRoute.of(context)!.settings.arguments as Venda?;

    _loadFormData(venda);
    preencherControllers(venda);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Venda'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  final isValid = _form.currentState!.validate();

                  if (isValid) {
                    _form.currentState?.save();

                    if (_id != null) {
                      _editar();
                    } else
                      _inserir();

                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.save)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      readOnly: true,
                      controller: _controllerVeiculo,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('*Veículo')),
                      onTap: () async {
                        selectedVeiculoId = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VeiculoList(ctxPrev: context)),
                        );
                        setState(() {
                          _controllerVeiculo.text = selectedVeiculoId != null
                              ? selectedVeiculoId.toString()
                              : '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veículo deve ser informado.";
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['veiculoId'] = value!,
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      readOnly: true,
                      controller: _controllerCliente,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('*Cliente')),
                      onTap: () async {
                        selectedClienteId = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClienteList(ctxPrev: context)),
                        );

                        _obterCliente();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Cliente deve ser informado.";
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['clienteId'] = value!,
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: _formData['entrada'],
                      enabled: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('*Entrada')),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Entrada deve ser informada.";
                        }

                        if (value.length < 0.0) {
                          return "Entrada inválida.";
                        }

                        return null;
                      },
                        
                      onSaved: (value) => _formData['entrada'] = value!,
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButtonFormField(
                        value: _formData['parcela'],
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Parcelas')),
                        items: parcelas.map((String parcelas) {
                          return DropdownMenuItem(
                            value: parcelas,
                            child: Text(parcelas),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o campo";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['parcela'] = value!)),
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  ListTile(
                    title: Text('Valor do carro:'),
                    trailing: Text('R\$' + valorVeiculo.toString()),
                  ),
                  ListTile(
                    title: Text('Valor da entrada:'),
                    trailing: Text('R\$' + valorEntrada),
                  ),
                  ListTile(
                    title: Text('Valor da comissão:'),
                    trailing: Text(
                        'R\$' + valorEntrada.toString()), //fazerCalculo 15%
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Total:'),
                    trailing: Text('R\$' + _realizarCalculoTotal().toString()),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }

  void _obterValorVeiculo() async {
    if (selectedVeiculoId != null) {
      final veiculo = await VeiculoRepository().byIndex(selectedVeiculoId);
      valorVeiculo = veiculo!.valor!;
    }
  }

  void _obterCliente() async {
    Cliente? cliente =
        await Provider.of<ClienteRepository>(context, listen: false)
            .byIndex(selectedClienteId);

    setState(() {
      _controllerCliente.text = selectedClienteId != null ? cliente!.nome : '';
    });
  }

  double _realizarCalculoTotal() {
    double valTotal = 0.0;
    return valTotal;
  }

  void _inserir() async {
    DateTime currentDate = DateTime.now();
    Provider.of<VendaRepository>(context, listen: false).insertVenda(Venda(
        idVeiculo: selectedVeiculoId,
        idCliente: selectedClienteId,
        entrada: _formData['entrada']!,
        parcelas: int.parse(_formData['parcela']!),
        data: currentDate.toString()));
  }

  void _editar() async {
    Provider.of<VendaRepository>(context, listen: false).editarVenda(
        _id!,
        selectedVeiculoId,
        selectedClienteId,
        _formData['entrada']!,
        int.parse(_formData['parcela']!));
  }

  String _formatarValorMonetarioString(double valor) {
    double valor = 1234.56;
    String valorFormatado =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);
    return valorFormatado;
  }

  double _converterEntrada(String entrada) {
    return double.parse(entrada);
  }
}
