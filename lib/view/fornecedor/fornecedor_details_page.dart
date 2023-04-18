import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/fornecedor.dart';
import 'package:vendas_veiculos/repository/fornecedor_repository.dart';

import 'package:intl/intl.dart';

class FornecedorDetailsPage extends StatefulWidget {
  final Fornecedor fornecedor;
  final nome = TextEditingController();
  final cnpj = TextEditingController();

  FornecedorDetailsPage({Key? key, required this.fornecedor}) : super(key: key) {
    nome.text = fornecedor.nome;
    cnpj.text = fornecedor.cnpj;
  }

  @override
  State<FornecedorDetailsPage> createState() => _FornecedorDetailsPageState();

}

  class _FornecedorDetailsPageState extends State<FornecedorDetailsPage> {
    final _formKey = GlobalKey<FormState>();
    static const _padding = EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20
    );

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (_formKey.currentState!.validate()) {
          context.read<FornecedorRepository>().updateFornecedor(
              widget.fornecedor,
              widget.nome.text,
              widget.cnpj.text,
          );
          return Future.value(true);
        }
        return Future.value(false);
      },
        child: Material(
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Colors.black,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppBar(
                    title: Text("Editar Fornecedor ${widget.fornecedor.nome}"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.read<FornecedorRepository>()
                              .deleteFornecedor(widget.fornecedor);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      controller: widget.nome,
                      validator: (value) {
                        if (value!.isEmpty) return 'Informe um nome';
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
                    padding: _padding,
                    child: TextFormField(
                      controller: widget.cnpj,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CnpjInputFormatter(),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) return 'Informe um CNPJ';
                        if (!UtilBrasilFields.isCNPJValido(value)) return 'CNPJ inválido';
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
        ),
      );
  }
}
