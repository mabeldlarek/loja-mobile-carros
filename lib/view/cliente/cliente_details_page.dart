import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/cliente_repository.dart';

import '../../model/cliente.dart';

class ClienteDetailsPage extends StatefulWidget {
  final Cliente cliente;
  final nome = TextEditingController();
  final cpf = TextEditingController();
  final email = TextEditingController();
  final celular = TextEditingController();

  ClienteDetailsPage({Key? key, required this.cliente}) : super(key: key) {
    nome.text = cliente.nome;
    cpf.text = cliente.cpf;
    email.text = cliente.email;
    celular.text = cliente.celular;
  }

  @override
  State<ClienteDetailsPage> createState() => _ClienteDetailsPageState();

}

  class _ClienteDetailsPageState extends State<ClienteDetailsPage> {
    final _formKey = GlobalKey<FormState>();
    static const _padding = EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20
    );

    String? _validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Informe um email válido'
          : null;
    }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (_formKey.currentState!.validate()) {
          context.read<ClienteRepository>().updateCliente(
              widget.cliente,
              widget.nome.text,
              widget.cpf.text,
              widget.email.text,
              widget.celular.text
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
                    title: Text("Editar Cliente ${widget.cliente.nome}"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.read<ClienteRepository>()
                              .deleteCliente(widget.cliente);
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
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      controller: widget.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('*Email'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: TextFormField(
                      controller: widget.celular,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      validator: (value) {
                        if (value!.length != 15) return 'Informe um celular válido';
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('*Celular'),
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
