import 'package:brasil_fields/brasil_fields.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:provider/provider.dart";

import '../../model/fornecedor.dart';
import '../../repository/fornecedor_repository.dart';

class AddFornecedorPage extends StatefulWidget {

  const AddFornecedorPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFornecedorPage> createState() => _AddFornecedorPageState();
}

class _AddFornecedorPageState extends State<AddFornecedorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _cnpj = TextEditingController();

  saveFornecedor() {
    if (_formKey.currentState!.validate()) {
      final fornecedorRepository = context.read<FornecedorRepository>();

      fornecedorRepository.saveFornecedor(
          Fornecedor(
            nome: _nome.text,
            cnpj: _cnpj.text,
          )
      );

      Navigator.of(context).pop();
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Adicionar Fornecedor'),
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
                controller: _cnpj,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CnpjInputFormatter(),
                ],
                validator: (value) {
                  if (value!.isEmpty) return 'Informe um CNPJ';
                  if (!UtilBrasilFields.isCNPJValido(value)) {
                    return 'CNPJ inválido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('*CNPJ'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      onPressed: () {
        Navigator.of(context).pushNamed(saveFornecedor());
      },
      child: const Icon(Icons.save),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
  );
}}
