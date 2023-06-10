import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/cliente_repository.dart';

import '../../model/cliente.dart';

class ClienteForm extends StatefulWidget {
  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _form = GlobalKey<FormState>();
  // associar com o formulário e acessar ele
  final Map<String, String> _formData = {};
  int? _id;
  late File? _imagemFile = null;
  late DateTime? _selectedDate = null;
  final List<String> tipos = ['COMPRADOR', 'FORNECEDOR'];
  String _selectedTipo = '';
  bool isCnpjFieldEnabled = false;

  void _loadFormData(Cliente? cliente) {
    if (cliente != null) {
      _id = cliente.idCliente;
      _formData['nome'] = cliente.nome!;
      _formData['cpf'] = cliente.cpf;
      _formData['cnpj'] = cliente.cnpj!;
      _formData['email'] = cliente.email!;
      _formData['celular'] = cliente.celular!;
      _selectedDate = DateTime.parse(cliente.dataNascimento);
      _formData['tipo'] = cliente.tipo;
      _selectedTipo = cliente.tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Cliente? cliente =
        ModalRoute.of(context)!.settings.arguments as Cliente?;

    _loadFormData(cliente);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Cliente'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  final isValid = _form.currentState!.validate();

                  if (isValid) {
                    _form.currentState
                        ?.save(); // chama o método pra cada um dos elementos do form

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
                        initialValue: _formData['nome'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('*Nome')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nome inválido";
                          }

                          if (value.length < 3 || value.length > 50) {
                            return "Nome deve conter de 3 a 50 caracteres";
                          }

                          return null;
                        },
                        onSaved: (value) => _formData['nome'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        initialValue: _formData['email'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*E-mail')),
                        validator: (value) {
                          if (value != null) {
                            if (!EmailValidator.validate(value!)) {
                              return "Email inválido";
                            }
                          }
                        },
                        onSaved: (value) => _formData['email'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _formData['cpf'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('*CPF')),
                        validator: (value) {
                          if (!UtilBrasilFields.isCPFValido(value)) {
                            return "CPF inválido";
                          }
                        },
                        onSaved: (value) => _formData['cpf'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                          value: _formData['tipo'],
                          decoration: InputDecoration(
                            label: Text('Tipo'),
                            border: OutlineInputBorder(),
                          ),
                          items: tipos.map((String tipo) {
                            return DropdownMenuItem<String>(
                              value: tipo,
                              child: Text(tipo),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _formData['tipo'] = newValue!;
                              if (_formData['tipo'] == "FORNECEDOR") {
                                isCnpjFieldEnabled = true;
                              } else{
                                isCnpjFieldEnabled = false;
                              }
                            });
                          },
                          onSaved: (value) => _formData['tipo'] = value!)),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        enabled: isCnpjFieldEnabled == true? true: false,
                        keyboardType: TextInputType.number,
                        initialValue: _formData['cnpj'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), label: Text('CNPJ')),
                        validator: (value) {
                          if (isCnpjFieldEnabled && !UtilBrasilFields.isCNPJValido(value)) {
                            return "CNPJ inválido";
                          }
                        },
                        onSaved: (value) => _formData['cnpj'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                         inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        initialValue: _formData['celular'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*Celular')),
                        validator: (value) {
                          if (value!.length != 15) {
                            return "Celular inválido";
                          }
                        },
                        onSaved: (value) => _formData['celular'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!)
                                : '',
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Data de Nascimento',
                            hintText: 'dd/mm/aaaa',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return 'Selecione uma data de nascimento válida';
                            }
                            if (!_validarIdade()) {
                              return 'A idade deve ser maior que 18 anos';
                            }
                          })),
                ],
              )),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _mudarTipo(String newValue) {}

  String _converterData() {
    String formattedDate = _selectedDate!.toIso8601String();
    return formattedDate;
  }

  void _inserir() async {
    Provider.of<ClienteRepository>(context, listen: false).insertCliente(
        Cliente(
            nome: _formData['nome']!,
            cpf: _formData['cpf']!,
            cnpj: _formData['cnpj']! == null ? '' : _formData['cnpj'],
            email: _formData['email']!,
            celular: _formData['celular']!,
            dataNascimento: _converterData(),
            tipo: _formData['tipo']!));
  }

  void _editar() async {
    Provider.of<ClienteRepository>(context, listen: false).editarCliente(
        _id!,
        _formData['nome']!,
        _formData['email']!,
        _formData['celular']!,
        _formData['cpf']!,
        _formData['cnpj']! ?? '',
        _converterData(),
        _formData['tipo']!);
  }

  bool _validarIdade() {
    final currentDate = DateTime.now();
    var idade = currentDate.year - _selectedDate!.year;

    if (currentDate.month < _selectedDate!.month ||
        (currentDate.month == _selectedDate!.month &&
            currentDate.day < _selectedDate!.day)) {
      idade--;
    }

    if (idade < 18) {
      return false;
    }

    return true;
  }
}
