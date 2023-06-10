import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/promocao.dart';
import '../../repository/promocao_repository.dart';
import '../../repository/veiculo_repository.dart';
import '../../utils/RealCurrencyInputFormatter.dart';
import '../veiculo/veiculo_lista.dart';

class PromocaoForm extends StatefulWidget {
  @override
  State<PromocaoForm> createState() => _PromocaoFormState();
}

class _PromocaoFormState extends State<PromocaoForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  int? _id;
  int? _selectedIdVeiculo = null;
  late DateTime? _selectedDataInicial = null;
  late DateTime? _selectedDataFinal = null;

  TextEditingController _controllerVeiculo = new TextEditingController();
  final TextEditingController _controller = TextEditingController();

  void _loadFormData(Promocao? promocao) {
    if (promocao != null) {
      _id = promocao.idPromocao!;
      _formData['idVeiculo'] = promocao.idVeiculo!.toString();
      _selectedDataInicial = DateTime.parse(promocao.dataInicial!);
      _selectedDataFinal = DateTime.parse(promocao.dataFinal!);
      _selectedIdVeiculo = promocao.idVeiculo;
    }
  }

  void _preencherControllers(promocao) async {
    if (promocao != null) {
      final veiculo = await VeiculoRepository().byIndex(promocao.idVeiculo!);
      final veiculoDescricao =
          await VeiculoRepository().obterDescricaoVeiculo(veiculo!);
      _controllerVeiculo.text = veiculoDescricao!;
      _controller.text = _formatCurrency(promocao.valor);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Promocao? promocao =
        ModalRoute.of(context)!.settings.arguments as Promocao?;

    _loadFormData(promocao);
    _preencherControllers(promocao);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulário de Promoção'),
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
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                    key: _form,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            readOnly: true,
                            controller: _controllerVeiculo,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('*Veículo')),
                            onTap: () async {
                              _selectedIdVeiculo = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VeiculoList(ctxPrev: context)),
                              );
                              setState(() {
                                _controllerVeiculo.text =
                                    _selectedIdVeiculo != null
                                        ? _selectedIdVeiculo.toString()
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
                              controller: TextEditingController(
                                text: _selectedDataInicial != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(_selectedDataInicial!)
                                    : '',
                              ),
                              onTap: () {
                                _selectDataInicial(context);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Data Inicial',
                                hintText: 'dd/mm/aaaa',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (_selectedDataInicial == null) {
                                  return 'Selecione uma data válida';
                                }
                              })),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              enabled: _selectedDataInicial != null? true : false,
                              readOnly: true,
                              controller: TextEditingController(
                                text: _selectedDataFinal != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(_selectedDataFinal!)
                                    : '',
                              ),
                              onTap: () {
                                _selectDataFinal(context);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Data Final',
                                hintText: 'dd/mm/aaaa',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (_selectedDataFinal == null) {
                                  return 'Selecione uma data válida';
                                }
                              })),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [RealCurrencyInputFormatter()],
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('*Valor promocional')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Valor promocional deve ser informado.";
                              }

                              if (value.length < 0.0) {
                                return "Valor promocional inválido";
                              }

                              return null;
                            },
                            onSaved: (value) => _formData['valor'] = value!,
                          ))
                    ])))));
  }

  Future<void> _selectDataInicial(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDataInicial ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDataInicial) {
      setState(() {
        _selectedDataInicial = picked;
      });
    }
  }

  String _formatCurrency(double value) {
    NumberFormat formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    String valorFormatado = formatadorMoeda.format(value);
    return valorFormatado;
  }

  Future<void> _selectDataFinal(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDataFinal ?? DateTime.now(),
        firstDate: _selectedDataInicial!,
        lastDate: _selectedDataInicial!.add(Duration(days: 30)),
      );

      if (picked != null && picked != _selectedDataFinal) {
        setState(() {
          _selectedDataFinal = picked;
        });
      }
  }

  String _converterData(DateTime dataSelecionada) {
    String formattedDate = dataSelecionada.toIso8601String();
    return formattedDate;
  }

  double _converterValorMonetario(String valor) {
    double parsedValue =
        double.parse(valor.replaceAll(RegExp(r'[^0-9]'), '')) / 100;
    return parsedValue;
  }

  double _converterValor(String valor) {
    return double.parse(valor);
  }

  void _inserir() async {
    print(_converterValorMonetario(_controller.text));
    Provider.of<PromocaoRepository>(context, listen: false).insertPromocao(
        Promocao(
            idVeiculo: _selectedIdVeiculo,
            dataFinal: _converterData(_selectedDataFinal!),
            dataInicial: _converterData(_selectedDataInicial!),
            valor: _converterValorMonetario(_controller.text)));
  }

  void _editar() async {
    Provider.of<PromocaoRepository>(context, listen: false).editarPromocao(
      _converterData(_selectedDataInicial!),
      _converterData(_selectedDataFinal!),
      _converterValorMonetario(_controller.text),
      _selectedIdVeiculo,
      _id,
    );
  }
}
