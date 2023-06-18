import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/components/modelo_tile_selecao.dart';
import 'package:vendas_veiculos/model/modelo.dart';
import 'package:vendas_veiculos/repository/modelo_repository.dart';

import '../../components/modelo_tile.dart';
import '../../model/marca.dart';
import '../../repository/marca_repository.dart';
import '../../routes/app_routes.dart';

class ModeloList extends StatelessWidget {
  BuildContext? contextPrevious;
  Map<String, String?>? filtros;

  ModeloList({super.key, BuildContext? ctxPrev, this.filtros}) {
    this.contextPrevious = ctxPrev;
  }

  @override
  Widget build(BuildContext context) {
    final ModeloRepository modelo = Provider.of(context);
    final MarcaRepository marca = Provider.of(context);
    modelo.database;
    List<Modelo> _modelo = [];
    Future<List<Modelo>> _list = filtros == null ? modelo.getModelos() : modelo.getModelosFlitered(filtros!);
    Future<List<Marca>> _marcas = marca.getMarcas();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Modelos'),
          actions: <Widget>[
            FutureBuilder<List<Marca>>(
              future: _marcas, // a Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<List<Marca>> snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _getDialog(context, snapshot.data);
                          }
                      ).then((filtrosSelecionados) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => ModeloList(
                                  filtros: filtrosSelecionados,
                                )
                            )
                        );
                      });
                    },
                    icon: const Icon(Icons.search),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.modeloForm);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder<List<Modelo>>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (ctx, i) => contextPrevious == null
                        ? ModeloTile(snapshot.data![i])
                        : ModeloTileSelecao(snapshot.data![i]));
              } else {
                return const CircularProgressIndicator();
              }
            }
        ));
  }

  AlertDialog _getDialog(BuildContext context, List<Marca>? marcas) {
    final _form = GlobalKey<FormState>();
    final Map<String, String?> _formData = {};
    int? _id;
    final List<String> numAssentos = ['2', '3', '5', '7', '8'];
    final List<String> numPortas = ['2', '4'];
    final List<String> possuiAr = ['SIM', 'NÃO'];
    String selectedPorta = '2';
    int? _selectedIdMarca;

    return AlertDialog(
      content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Filtros"),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          initialValue: _formData['nome'],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), label: Text('Nome')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nome inválido";
                            }

                            if (value.length < 2 || value.length > 10) {
                              return "Nome deve conter de 3 a 10 caracteres";
                            }

                            return null;
                          },
                          onSaved: (value) => _formData['nome'] = value,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButtonFormField<int>(
                          value: _selectedIdMarca,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Marca',
                          ),
                          items: marcas?.map((marca) {
                            return DropdownMenuItem<int>(
                              value: marca.idMarca,
                              child: Text(marca.nome!),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            _selectedIdMarca = newValue;
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
                              border: OutlineInputBorder(), label: Text('Ano')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (value!.length < 4 || value.length > 4) {
                                return "Ano inválido";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) => _formData['ano'] = value,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: _formData['codigoFipe'],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Código Fipe')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Código inválido";
                            }
                            if (value!.length != 7) {
                              return "Código inválido";
                            }
                            return null;
                          },

                          onSaved: (value) => _formData['codigoFipe'] = value,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButtonFormField<String>(
                            value: _formData['numPortas'],
                            decoration: const InputDecoration(
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
                              _formData['numPortas'] = newValue;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Informe o campo";
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['numPortas'] = value)),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButtonFormField<String>(
                          value: _formData['numAssentos'],
                          decoration: const InputDecoration(
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
                            _formData['numAssentos'] = newValue;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Informe o campo";
                            }
                            return null;
                          },
                          onSaved: (value) => _formData['numAssentos'] = value,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          initialValue: _formData['quilometragem'],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Quilometragem')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Quilometragem inválida";
                            }
                            return null;
                          },
                          onSaved: (value) => _formData['quilometragem'] = value,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButtonFormField<String>(
                            value: _formData['possuiAr'],
                            decoration: const InputDecoration(
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
                              _formData['possuiAr'] = newValue;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Informe o campo";
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['possuiAr'] = value
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: OutlinedButton(
                        onPressed: () {
                          _form.currentState?.save();
                          Navigator.pop(context, _formData);
                        },
                        child: const Text("Filtrar"),
                      ),
                    ),
                  ],
                )),

          )),
    );
  }
}
