import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/session.dart';
import '../../model/cliente.dart';
import '../../model/veiculo.dart';
import '../../model/venda.dart';
import '../../repository/cliente_repository.dart';
import '../../repository/veiculo_repository.dart';
import '../../repository/venda_repository.dart';
import '../../utils/RealCurrencyInputFormatter.dart';
import '../cliente/cliente_list.dart';
import '../veiculo/veiculo_list.dart';

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
  TextEditingController _controllerValorVeiculo = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _obterValorVeiculo();
    });
  }

  @override
  void dispose() {
    _controllerEntrada.dispose();
    super.dispose();
  }

  String dropdownvalue = '';
  var valorVeiculo = 0.0;
  var valorEntrada = 0.0;
  int? _id;
  String? _data;
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
      _controllerEntrada.text = valorEntrada == 0.0
          ? _formatCurrency(venda.entrada)
          : _formatCurrency(valorEntrada);
      print("valor é ${_controllerValorVeiculo.text}");
    }
  }

  void _loadFormData(Venda? venda) {
    if (venda != null) {
      _id = venda.idVenda;
      _data = venda.data;
      selectedVeiculoId = venda.idVeiculo;
      selectedClienteId = venda.idCliente;
      _formData['parcela'] = venda.parcelas!.toString();
    }
  }

  Future<String> obterValorVeiculo() async {
    if(selectedVeiculoId != null) {
      final veiculo = await VeiculoRepository().byIndex(selectedVeiculoId);
      valorVeiculo = veiculo!.valor;
      return _formatCurrency(veiculo!.valor);
    }
   return '';
  }

  Future<String> obterValorEntrada(venda) async {
     if (venda != null ) {
      valorEntrada = venda!.entrada;
      return _formatCurrency(venda!.entrada);
    }
    if(_controllerEntrada.text!=null){
      return _formatCurrency(valorEntrada);
    }
   
    return '';
  }

  Future<String> obterValorComissao() async {
    if (selectedVeiculoId != null) {
      final veiculo = await VeiculoRepository().byIndex(selectedVeiculoId);
      return _formatCurrency(veiculo!.valor! * 0.05);
    }
    return '';
  }

  Future<String> obterValorParcela(venda) async {
    if(_formData['parcela'] != null){
      final veiculo = await VeiculoRepository().byIndex(selectedVeiculoId);
      return _formatCurrency((veiculo!.valor - valorEntrada) / int.parse(_formData['parcela']!));
    }
    return '';
  }

  Future<String> obterValorTotal(venda) async {
    if (selectedVeiculoId != null) {
      final veiculo = await VeiculoRepository().byIndex(selectedVeiculoId);
      return _formatCurrency(veiculo!.valor! - valorEntrada);
    }
    return '';
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
          padding: EdgeInsets.all(30),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
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
                          if(selectedVeiculoId != null){
                            _obterVeiculo();
                            _obterValorVeiculo();
                          }
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
                      controller: _controllerEntrada,
                      keyboardType: TextInputType.number,
                      inputFormatters: [RealCurrencyInputFormatter()],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('*Valor de Entrada')),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Valor de entrada deve ser informado.";
                        }

                        if (value.length < 0.0) {
                          return "Valor de entrada inválido";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        _controllerEntrada.text = value;
                        valorEntrada = _converterValorMonetario(value);
                        _controllerEntrada.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: _controllerEntrada.text.length),
                        );
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
                            _formData['parcela'] = newValue;
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
                    trailing: FutureBuilder<String>(
                      future: obterValorVeiculo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Text(snapshot.data ?? '');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Valor da entrada:'),
                    trailing: FutureBuilder<String>(
                      future: obterValorEntrada(venda),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Text(snapshot.data ?? '');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Valor da comissão:'),
                    trailing: FutureBuilder<String>(
                      future: obterValorComissao(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Text(snapshot.data ?? '');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Valor Parcela:'),
                    trailing: FutureBuilder<String>(
                      future: obterValorParcela(venda),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Text(snapshot.data ?? '');
                      },
                    ),
                  ),
                  Divider(),
                   ListTile(
                    title: Text('Valor Total:'),
                    trailing: FutureBuilder<String>(
                      future: obterValorTotal(venda),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Text(snapshot.data ?? '');
                      },
                    ),
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
        )));
  }

  void _atualizarValorDoController(String valor) {
    String novoValor = valor; 
    _controllerEntrada.text = novoValor;
  }

  void _obterValorVeiculo() async {
    if (selectedVeiculoId != null) {
      final veiculo = await VeiculoRepository().byIndex(selectedVeiculoId);
      valorVeiculo = veiculo!.valor!;
      _controllerValorVeiculo.text = _formatCurrency(valorVeiculo);
    }
  }

  double _converterValorMonetario(String valor) {
    double parsedValue =
        double.parse(valor.replaceAll(RegExp(r'[^0-9]'), '')) / 100;
    return parsedValue;
  }

  void _obterCliente() async {
    Cliente? cliente =
        await Provider.of<ClienteRepository>(context, listen: false)
            .byIndex(selectedClienteId);

    setState(() {
      _controllerCliente.text = selectedClienteId != null ? cliente!.nome : '';
    });
  }

  void _obterVeiculo() async {
    Veiculo? veiculo =
        await Provider.of<VeiculoRepository>(context, listen: false)
            .byIndex(selectedVeiculoId);
    
    String? descricao = await Provider.of<VeiculoRepository>(context, listen: false).obterDescricaoVeiculo(veiculo!);

    setState(() {
      _controllerVeiculo.text = selectedVeiculoId != null ?  descricao! : '';
    });
  }

  double _calcularTotalComissao() {
    return valorVeiculo * 0.15;
  }

  double _realizarCalculoTotal() {
    double valTotal = (valorVeiculo - valorEntrada) - _calcularTotalComissao();
    return valTotal;
  }

  String _formatCurrency(double value) {
    NumberFormat formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    String valorFormatado = formatadorMoeda.format(value);
    return valorFormatado;
  }

  void _inserir() async {
    DateTime currentDate = DateTime.now();
    Provider.of<VendaRepository>(context, listen: false).insertVenda(Venda(
        idVeiculo: selectedVeiculoId,
        idCliente: selectedClienteId,
        idVendedor: Session.id,
        entrada: _converterValorMonetario(_controllerEntrada.text),
        parcelas: int.parse(_formData['parcela']!),
        data: currentDate.toString()));
  }

  void _editar() async {
    Provider.of<VendaRepository>(context, listen: false).editarVenda(
        _id!,
        selectedVeiculoId,
        Session.id!,
        selectedClienteId,
        _converterValorMonetario(_controllerEntrada.text),
        int.parse(_formData['parcela']!),
        _data!);
  }

  double _converterEntrada(String entrada) {
    return double.parse(entrada);
  }
}
