import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/repository/agenda_repository.dart';

import '../../model/agenda.dart';
import '../../data/session.dart';

class AgendaForm extends StatefulWidget {
  @override
  State<AgendaForm> createState() => _AgendaFormState();
}

class _AgendaFormState extends State<AgendaForm> {
  bool _isEditing = false;
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  int? _id;
  final TextEditingController _dateController = TextEditingController();
  late DateTime? _selectedDate = null;

  void _loadFormData(Agenda? agenda) {
    if (agenda != null) {
      _id = agenda.idAgenda;
      _formData['titulo'] = agenda.titulo;
      _formData['descricao'] = agenda.descricao!;
      if (_selectedDate == null &&
          agenda.dataHora != null &&
          agenda.dataHora.isNotEmpty) {
        DateTime? newDateTime = DateTime.parse(agenda.dataHora);
        if (_selectedDate != newDateTime) {
          _selectedDate = newDateTime;
          _updateDateText();
        }
      }
    }
  }

  void _updateDateText() {
    _dateController.text = _selectedDate != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate!)
        : '';
  }

  @override
  void initState() {
    super.initState();
    _updateDateText();
  }

  @override
  Widget build(BuildContext context) {
    final Agenda? agenda =
        ModalRoute.of(context)!.settings.arguments as Agenda?;
    _isEditing = (agenda != null);
    _loadFormData(agenda);

    return Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editando Evento' : 'Criando Evento'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  final isValid = _form.currentState!.validate();
                  if (isValid) {
                    _form.currentState?.save();
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
                        initialValue: _formData['titulo'],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('*Título')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Indique um título válido";
                          }
                          if (value.length < 3 || value.length > 50) {
                            return "O título deve conter de 3 a 50 caracteres";
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['titulo'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        minLines: 6,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        initialValue: _formData['descricao'],
                        decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                            label: Text('*Descrição')),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 10) {
                            return "Informe uma descrição (min. 10 caracteres)";
                          }
                        },
                        onSaved: (value) => _formData['descricao'] = value!,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: () {
                            _selectDate(context);
                          },
                          onChanged: (value) {
                            _updateDateText();
                          },
                          decoration: const InputDecoration(
                            labelText: '*Data/Hora',
                            hintText: 'dd/mm/aaaa HH:mm',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return 'Selecione uma data válida';
                            }
                          })),
                ],
              )),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
      _updateDateText();
    }
  }

  String _converterData() {
    String formattedDate = _selectedDate!.toIso8601String();
    return formattedDate;
  }

  void _inserir() async {
    Provider.of<AgendaRepository>(context, listen: false).insertAgenda(Agenda(
        idVendedor: Session.id ?? 2,
        titulo: _formData['titulo']!,
        descricao: _formData['descricao']!,
        dataHora: _converterData()));
  }

  void _editar() async {
    Provider.of<AgendaRepository>(context, listen: false).editarAgenda(
        _id!, _formData['titulo']!, _formData['descricao']!, _converterData());
  }
}
