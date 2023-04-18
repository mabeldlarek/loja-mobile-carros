import 'package:brasil_fields/brasil_fields.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import "package:provider/provider.dart";

import '../../model/vendedor.dart';
import '../../repository/vendedor_repository.dart';

class AddVendedorPage extends StatefulWidget {

  const AddVendedorPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddVendedorPage> createState() => _AddVendedorPageState();
}

class _AddVendedorPageState extends State<AddVendedorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  var _selectedDate = DateTime.now();

  saveVendedor() {
    if (_formKey.currentState!.validate()) {
      final vendedorRepository = context.read<VendedorRepository>();

      vendedorRepository.saveVendedor(
        Vendedor(
          nome: _nome.text,
          cpf: _cpf.text,
          dataNascimento: DateFormat("dd/MM/yyyy").format(_selectedDate)
        )
      );

      Navigator.of(context).pop();
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1910, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Vendedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: _nome,
                  validator: (value) {
                    if (value!.isEmpty) return 'Informe um Nome';
                    if (value.length < 5) return 'Escreva 5 caracteres';
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('*Nome'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  // obscureText: !showPass,
                  controller: _cpf,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return 'Informe um CPF';
                    if (!UtilBrasilFields.isCPFValido(value)) return 'CPF inválido';
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('*CPF'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('*Data de Nascimento'),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24
                          ),
                          child: Text(DateFormat("dd/MM/yyyy").format(_selectedDate)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24
                          ),
                          child: ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Escolher Data'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).pushNamed(saveVendedor());
        },
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
