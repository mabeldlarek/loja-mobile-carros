import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/veiculo.dart';
import '../../repository/cliente_repository.dart';
import '../../repository/marca_repository.dart';
import '../../repository/modelo_repository.dart';
import '../../repository/promocao_repository.dart';
import '../../repository/veiculo_repository.dart';
import '../../utils/RealCurrencyInputFormatter.dart';
import '../cliente/cliente_list.dart';
import '../modelo/modelo_list.dart';

class VeiculoForm extends StatefulWidget {
  @override
  State<VeiculoForm> createState() => _VeiculoFormState();
}

class _VeiculoFormState extends State<VeiculoForm> {
  final _form = GlobalKey<FormState>();
  // associar com o formulário e acessar ele
  final Map<String, String> _formData = {};
  int? _id;
  final _tipoLista = ["USADO", "NOVO", "SEMINOVO"];
  final _corLista = ["BRANCO", "PRETO", "AZUL", "CINZA"];
  final TextEditingController _controllerModelo = new TextEditingController();
  final TextEditingController _controllerFornecedor = new TextEditingController();
  final TextEditingController _controller = TextEditingController();


  var _modeloSelecionadoId = null;
  var _fornecedorSelecionadoId = null;
  var _selectedTipo = null;
  var _selectedCor = null;

  void preencherControllers(veiculo) async {
    if (veiculo != null) {
      final cliente = await ClienteRepository().byIndex(veiculo.idFornecedor);
      final modelo = await ModeloRepository().byIndex(veiculo.idModelo);
      final marca = await MarcaRepository().byIndex(modelo!.idMarca!);
      final promocao = await PromocaoRepository().byVeiculo(veiculo.idVeiculo!);

      _controllerModelo.text =
          '${marca!.nome!}/${modelo.nome!} - ${modelo.ano!}';
      _controllerFornecedor.text = cliente!.nome;
      _controller.text = promocao==null? _formatCurrency(veiculo.valor): _formatCurrency(promocao.valor);
    }
  }

  void _loadFormData(Veiculo? veiculo) async {
    if (veiculo != null) {
      _id = veiculo.idVeiculo;
      _modeloSelecionadoId = veiculo.idModelo;
      _fornecedorSelecionadoId = veiculo.idFornecedor;
      _formData['idModelo'] = veiculo.idModelo!.toString();
      _formData['idFornecedor'] = veiculo.idFornecedor!.toString();
      _formData['tipo'] = veiculo.tipo!;
      _formData['placa'] = veiculo.placa!;
      _formData['cor'] = veiculo.cor!;
      _formData['valor'] = veiculo.valor.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Veiculo? veiculo =
        ModalRoute.of(context)!.settings.arguments as Veiculo?;
    _loadFormData(veiculo);
    preencherControllers(veiculo);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Veiculos'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  final isValid = _form.currentState!.validate();

                  if (isValid) {
                    _form.currentState?.save();

                    if (_id != null) {
                      _editar();
                    } else {
                      _inserir();
                    }

                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.save)),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        readOnly: true,
                        controller: _controllerModelo,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*Modelo')),
                        onTap: () async {
                          _modeloSelecionadoId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ModeloList(ctxPrev: context)),
                          );
                          _obterModelo();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Modelo deve ser informado.";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['idModelo'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        readOnly: true,
                        controller: _controllerFornecedor,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*Fornecedor')),
                        onTap: () async {
                          _fornecedorSelecionadoId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClienteList(
                                    ctxPrev: context, somenteFornecedor: true)),
                          );
                          _obterCliente();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Fornecedor deve ser informado.";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['idFornecedor'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField(
                          value: _formData['cor'],
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Cores')),
                          items: _corLista.map((String cor) {
                            return DropdownMenuItem(
                              value: cor,
                              child: Text(cor),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCor = newValue!;
                            });
                          },
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o campo";
                          }
                          return null;
                        },
                          onSaved: (value) => _formData['cor'] = value!)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField(
                          value: _formData['tipo'],
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Tipos')),
                          items: _tipoLista.map((String tipo) {
                            return DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTipo = newValue!;
                            });
                          },
                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o campo";
                          }
                          return null;
                        },
                          onSaved: (value) => _formData['tipo'] = value!)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        initialValue: _formData['placa'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('Placa')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Placa deve ser informada.";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['placa'] = value!,
                      )),
                   Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [RealCurrencyInputFormatter()],
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('*Valor')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Valor do veículo deve ser informado.";
                              }

                              if (value.length < 0.0) {
                                return "Valor do veículo inválido";
                              }

                              return null;
                            },
                            onSaved: (value) => _formData['valor'] = value!,
                          ))
                ],
              )),
            )));
  }

  void _obterCliente() async {
    final cliente = await Provider.of<ClienteRepository>(context, listen: false)
        .byIndex(_fornecedorSelecionadoId);

    setState(() {
      _controllerFornecedor.text =
          _fornecedorSelecionadoId != null ? cliente!.nome : '';
    });
  }

  void _obterModelo() async {
    String? nomeModelo;
    String? ano;
    String? nomeMarca;

    if (_modeloSelecionadoId != null) {
      final modelo = await Provider.of<ModeloRepository>(context, listen: false)
          .byIndex(_modeloSelecionadoId);

      final marca = await Provider.of<MarcaRepository>(context, listen: false)
          .byIndex(modelo!.idMarca!);
      nomeModelo = modelo.nome!;
      ano = modelo.ano!;
      nomeMarca = marca!.nome!;
    }

    setState(() {
      _controllerModelo.text =
          _modeloSelecionadoId != null ? '$nomeModelo / $nomeMarca - $ano' : '';
    });
  }

  double _converterValorMonetario(String valor) {
    double parsedValue =
        double.parse(valor.replaceAll(RegExp(r'[^0-9]'), '')) / 100;
    return parsedValue;
  }

  String _formatCurrency(double value) {
    NumberFormat formatadorMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    String valorFormatado = formatadorMoeda.format(value);
    return valorFormatado;
  }

  void _inserir() async {
    Provider.of<VeiculoRepository>(context, listen: false).insertVeiculo(
       Veiculo(
            idModelo: _modeloSelecionadoId,
            idFornecedor: _fornecedorSelecionadoId,
            valor: _converterValorMonetario(_formData['valor']!),
            tipo: _formData['tipo'],
            cor: _formData['cor'],
            placa: _formData['placa']));
  }

  void _editar() async {
    Provider.of<VeiculoRepository>(context, listen: false).editarVeiculo(
      _id,
      _modeloSelecionadoId,
      _fornecedorSelecionadoId,
      _converterValorMonetario(_formData['valor']!),
      _formData['tipo'],
      _formData['cor'],
      _formData['placa'],
    );
  }
}
