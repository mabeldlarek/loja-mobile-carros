import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/model/vendedor.dart';
import 'package:vendas_veiculos/repository/vendedor_repository.dart';

import 'package:intl/intl.dart';

class VendedorDetailsPage extends StatefulWidget {
  final Vendedor vendedor;
  final nome = TextEditingController();
  final cpf = TextEditingController();

  VendedorDetailsPage({Key? key, required this.vendedor}) : super(key: key) {
    nome.text = vendedor.nome;
    cpf.text = vendedor.cpf;
  }

  @override
  State<VendedorDetailsPage> createState() => _VendedorDetailsPageState();

}

  class _VendedorDetailsPageState extends State<VendedorDetailsPage> {
    late var _selectedDate = widget.vendedor.dataNascimento;
    final _formKey = GlobalKey<FormState>();
    static const _padding = EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20
    );

    _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1910, 1),
          lastDate: DateTime.now());
      if (picked != null
          && DateFormat("dd/MM/yyyy").format(picked) != _selectedDate) {
        setState(() {
          _selectedDate = DateFormat("dd/MM/yyyy").format(picked);
        });
      }
    }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (_formKey.currentState!.validate()) {
          context.read<VendedorRepository>().updateVendedor(
              widget.vendedor,
              widget.nome.text,
              widget.cpf.text,
              _selectedDate
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
                    title: const Text("Editar Vendedor"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.read<VendedorRepository>()
                              .deleteVendedor(widget.vendedor);
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
                      controller: widget.cpf,
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
                    margin: _padding,
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
                              child: Text(_selectedDate),
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
        ),
      );
  }
}
