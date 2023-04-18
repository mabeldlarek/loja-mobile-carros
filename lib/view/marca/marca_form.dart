import 'package:flutter/material.dart';
import 'package:vendas_veiculos/provider/marcas.dart';
import 'package:provider/provider.dart';

import '../../model/marca.dart';

class MarcaForm extends StatefulWidget {
  @override
  State<MarcaForm> createState() => _MarcaFormState();
}

class _MarcaFormState extends State<MarcaForm> {
  final _form =
      GlobalKey<FormState>(); 
 // associar com o formulário e acessar ele
  final Map<String, String> _formData = {};

  void _loadFormData(Marca marca) {
    _formData['id'] = marca.id!;
    _formData['nome'] = marca.nome!;
    _formData['imageUrl'] = marca.imageUrl!;
  }

  @override
  Widget build(BuildContext context) {
    final Marca marca = ModalRoute.of(context)!.settings.arguments as Marca;

    _loadFormData(marca);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Usuário'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  final isValid = _form.currentState!.validate();

                  if (isValid) {
                    _form.currentState
                        ?.save(); // chama o método pra cada um dos elementos do form

                    Provider.of<Marcas>(context, listen: false).put(Marca(
                      id: _formData['id'],
                      nome: _formData['nome'],
                      imageUrl: _formData['imageUrl'],
                    ));

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
                children: <Widget>[
                  TextFormField(
                    initialValue: _formData['nome'],
                    decoration: const InputDecoration(labelText: 'Nome'),
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
                  ),
                  TextFormField(
                    initialValue: _formData['imageUrl'],
                    decoration: const InputDecoration(labelText: 'Logo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Imagem inválida";
                      }
                    },
                    onSaved: (value) => _formData['imageUrl'] = value!,
                  ),
                ],
              )),
        ));
  }
}
