import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/marca_repository.dart';

import '../../model/marca.dart';

class MarcaForm extends StatefulWidget {
  @override
  State<MarcaForm> createState() => _MarcaFormState();
}

class _MarcaFormState extends State<MarcaForm> {
  final _form = GlobalKey<FormState>();
  // associar com o formulário e acessar ele
  final Map<String, String> _formData = {};
  int? _id;
  late File? _imagemFile = null;

  void _loadFormData(Marca? marca) {
    if (marca != null) {
      _id = marca.idMarca;
      _imagemFile = File(marca.imagem!);
      _formData['nome'] = marca.nome!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Marca? marca = ModalRoute.of(context)!.settings.arguments as Marca?;

    _loadFormData(marca);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario de Marca'),
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
                          if (value!.isEmpty) return 'Informe um Nome';
                          if (value.length < 5) return 'Minímo 3 caracteres';
                          return null;
                        },
                        onSaved: (value) => _formData['nome'] = value!,
                      )),
                  GestureDetector(
                     onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Selecione uma imagem'),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => pickImage(),
                                  child: Icon(Icons.photo_library),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                         width: 150.0,
                         height: 150.0,
                      child:_imagemFile == null
                          ? Icon(Icons.camera_alt, size: 50.0,)
                          : Image.file(_imagemFile!, fit: BoxFit.cover),
                    )),
                ],
              )),
        ));
  }

  void _inserir() async {
    Provider.of<MarcaRepository>(context, listen: false).insertMarca(
        Marca(nome: _formData['nome'], imagem: _imagemFile == null ? null : _imagemFile!.path));
  }

  void _editar() async {
    Provider.of<MarcaRepository>(context, listen: false)
        .editarMarca(_id!, _formData['nome']!, _imagemFile!.path);
  }

  Future<void> saveImage(File image) async {
    final directory = await getExternalStorageDirectory();
    final imagePath = '${directory?.path}/my_image.png';
    final newImage = await image.copy(imagePath);
    // Confirma se o arquivo foi salvo com sucesso
    final isSaved = await newImage.exists();
    print(isSaved
        ? 'Imagem salva com sucesso! $imagePath'
        : 'Falha ao salvar a imagem.');
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagemFile = File(image.path);;
      });
      //saveImage(_imagemFile!);
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }
}
