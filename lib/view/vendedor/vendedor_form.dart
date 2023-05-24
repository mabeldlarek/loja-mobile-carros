import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/vendedor.dart';
import '../../repository/vendedor_repository.dart';

class VendedorForm extends StatefulWidget {
  @override
  State<VendedorForm> createState() => _VendedorFormState();
}

class _VendedorFormState extends State<VendedorForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  late DateTime? _selectedDate = null;
  int? _id;

  void _loadFormData(Vendedor? vendedor) {
    if (vendedor != null) {
      _id = vendedor.idVendedor;
      _formData['nome'] = vendedor.nome!;
      _formData['cpf'] = vendedor.cpf!;
      _formData['email'] = vendedor.email!;
      _formData['senha'] =
      vendedor.senha!; // botar iconezinho de mostrar ou não a senha?
      _selectedDate = DateTime.parse(vendedor.dataNascimento);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Vendedor? vendedor =
    ModalRoute.of(context)!.settings.arguments as Vendedor?;

    _loadFormData(vendedor);

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Vendedor'),
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
          padding: const EdgeInsets.all(15),
          child: Form(
              key: _form,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: TextFormField(
                      initialValue: _formData['cpf'],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text('*CPF')),
                      validator: (value) {
                        if (!UtilBrasilFields.isCPFValido(value)) {
                          return "CPF inválido";
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['cpf'] = value!,
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child:TextFormField(
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
                          if(!_validarIdade()){
                            return 'A idade deve ser maior que 18 anos';
                          }
                        })),
              ],
            )
          ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child:TextFormField(
                initialValue: _formData['email'],
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('*E-mail')),
                validator: (value) {
                  if (value != null) {
                    if (!EmailValidator.validate(value)) {
                      return "Email inválido";
                    }
                  }
                  return null;
                },
                onSaved: (value) => _formData['email'] = value!,
              ))),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextFormField(
            initialValue: _formData['senha'],
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('*Senha')),
            validator: (value) {
              if (value != null) {
                if (value.length < 5 || value.length > 10) {
                  return "Senha inválida";
                }
              }
            },
            onSaved: (value) => _formData['senha'] = value!,
          )),
    ]),
    )));
  }

  void _inserir() async {
    Provider.of<VendedorRepository>(context, listen: false).insertVendedor(
        Vendedor(
            nome: _formData['nome']!,
            dataNascimento: _converterData(),
            cpf: _formData['cpf']!,
            email: _formData['email']!,
            senha: _formData['senha']!));
  }

  void _editar() async {
    Provider.of<VendedorRepository>(context, listen: false).editarVendedor(
        _id!,
        _formData['nome']!,
        _converterData(),
        _formData['cpf']!,
        _formData['email']!,
        _formData['senha']!);
  }

  String _converterData() {
    String formattedDate = _selectedDate!.toIso8601String();
    return formattedDate;
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
