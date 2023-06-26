import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/marca_repository.dart';

import '../../model/marca.dart';
import '../../model/modelo.dart';
import '../../repository/modelo_repository.dart';

class ModeloForm extends StatefulWidget {
  @override
  State<ModeloForm> createState() => _ModeloFormState();
}

class _ModeloFormState extends State<ModeloForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  List<Marca> _marcas = [];
  int? _id;
  final List<String> numAssentos = ['2', '3', '5', '7', '8'];
  final List<String> numPortas = ['2', '4'];
  final List<String> possuiAr = ['SIM', 'NÃO'];
  String selectedPorta = '2';
  int? _selectedIdMarca = null;

  void _loadFormData(Modelo? modelo) {
    if (modelo != null) {
      _id = modelo.idModelo!;
      _formData['idMarca'] = modelo.idMarca!.toString();
      _formData['nome'] = modelo.nome!;
      _formData['ano'] = modelo.ano!;
      _formData['codigoFipe'] = modelo.codigoFipe!;
      _formData['numPortas'] = modelo.numeroPortas!.toString();
      _formData['numAssentos'] = modelo.numeroAssentos!.toString();
      _formData['quilometragem'] = modelo.quilometragem.toString();
      _formData['possuiAr'] = modelo.possuiAr!;
      _selectedIdMarca = modelo.idMarca!;
      String portaSelecionada = '2';
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarMarcas();
  }

  Future<void> _carregarMarcas() async {
    List<Marca> marcas =
        await Provider.of<MarcaRepository>(context, listen: false).getMarcas();
    setState(() {
      _marcas = marcas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Modelo? modelo = ModalRoute.of(context)!.settings.arguments as Modelo?;

    _loadFormData(modelo);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Modelo'),
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
          padding: EdgeInsets.all(15),
          child: Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        initialValue: _formData['nome'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('*Nome')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nome inválido";
                          }

                          if (value.length < 2 || value.length > 10) {
                            return "Nome deve conter de 3 a 10 caracteres";
                          }

                          return null;
                        },
                        onSaved: (value) => _formData['nome'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<int>(
                        value: _selectedIdMarca,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Marca',
                        ),
                        items: _marcas.map((marca) {
                          return DropdownMenuItem<int>(
                            value: marca.idMarca,
                            child: Text(marca.nome!),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedIdMarca = newValue;
                          });
                        },
                        onSaved: (value) =>
                            _formData['idMarca'] = value.toString(),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _formData['ano'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('*Ano')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if (value!.length < 4 || value.length > 4) {
                              return "Ano inválido";
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['ano'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _formData['codigoFipe'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*Código Fipe')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Código inválido";
                          }
                          if (value!.length != 7) {
                            return "Código inválido";
                          }
                          return null;
                        },
                        
                        onSaved: (value) => _formData['codigoFipe'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                          value: _formData['numPortas'],
                          decoration: InputDecoration(
                            labelText: 'Número de Portas',
                            border: OutlineInputBorder(),
                          ),
                          items: numPortas.map((String numPorta) {
                            return DropdownMenuItem<String>(
                              value: numPorta,
                              child: Text(numPorta),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _formData['numPortas'] = newValue!;
                            });
                          },
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o campo";
                          }
                          return null;
                        },
                          onSaved: (value) => _formData['numPortas'] = value!)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                        value: _formData['numAssentos'],
                        decoration: InputDecoration(
                          labelText: 'Número de Assentos',
                          border: OutlineInputBorder(),
                        ),
                        items: numAssentos.map((String numAssento) {
                          return DropdownMenuItem<String>(
                            value: numAssento,
                            child: Text(numAssento),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _formData['numAssentos'] = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o campo";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['numAssentos'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        initialValue: _formData['quilometragem'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*Quilometragem')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Quilometragem inválida";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['quilometragem'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                          value: _formData['possuiAr'],
                          decoration: InputDecoration(
                            labelText: 'Possui Ar Condicionado?',
                            border: OutlineInputBorder(),
                          ),
                          items: possuiAr.map((String possuiAr) {
                            return DropdownMenuItem<String>(
                              value: possuiAr,
                              child: Text(possuiAr),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _formData['possuiAr'] = newValue!;
                            });
                          },
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o campo";
                          }
                          return null;
                        },
                           onSaved: (value) => _formData['possuiAr'] = value!)),
                ],
              )),
        )));
  }

  double _converterQuilometragem(String quilometragemString) {
    return double.parse(quilometragemString);
  }

  void _inserir() async {
    Provider.of<ModeloRepository>(context, listen: false).insertModelo(Modelo(
        nome: _formData['nome'],
        idMarca: _selectedIdMarca,
        ano: _formData['ano'],
        codigoFipe: _formData['codigoFipe'],
        numeroPortas: int.parse(_formData['numPortas']!),
        numeroAssentos: int.parse(_formData['numAssentos']!),
        quilometragem: _converterQuilometragem(_formData['quilometragem']!),
        possuiAr: _formData['possuiAr']!));
  }

  void _editar() async {
    Provider.of<ModeloRepository>(context, listen: false).editarModelo(
      _formData['nome'],
      _selectedIdMarca,
      _id,
      _formData['ano'],
      _formData['codigoFipe'],
      _formData['numPortas'],
      _formData['numAssentos'],
      _converterQuilometragem(_formData['quilometragem']!),
      _formData['possuiAr']!,
    );
  }
}
