import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/components/agenda_tile_selecao.dart';
import '../../components/agenda_tile.dart';
import '../../model/agenda.dart';
import '../../repository/agenda_repository.dart';
import '../../routes/app_routes.dart';

enum Order { asc, desc }

class AgendaList extends StatefulWidget {
  final BuildContext? contextoAnterior;

  const AgendaList({Key? key, this.contextoAnterior}) : super(key: key);

  @override
  _AgendaListState createState() => _AgendaListState();
}

class _AgendaListState extends State<AgendaList> {
  Order _ordenacao = Order.asc;
  String _termo = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final AgendaRepository agendaRepository =
    Provider.of<AgendaRepository>(context);
    List<Agenda> list = [];
    Future<List<Agenda>> futureList;

    futureList = agendaRepository.getEventos();

    return Scaffold(
      appBar: AppBar(
        title: _termo.isNotEmpty ? Text('Pesquisa: $_termo') : Text('Agenda'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _ordenacao =
                _ordenacao == Order.asc ? Order.desc : Order.asc;
              });
            },
            icon: Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _PesquisaAgenda(),
              ).then((query) {
                if (query != null) {
                  setState(() {
                    _termo = query;
                  });
                }
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _dateRangePicker(context);
            },
            icon: Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.agendaForm);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Agenda>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data ?? [];
            list = _aplicarOrdenacao(list);
            final List<Agenda> filteredList = _aplicarFiltragem(list);

            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (ctx, i) => widget.contextoAnterior == null
                  ? AgendaTile(filteredList[i])
                  : AgendaTileSelecao(filteredList[i]),
            );
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> _dateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  List<Agenda> _aplicarOrdenacao(List<Agenda> list) {
    list.sort((a, b) {
      return _ordenacao == Order.asc
          ? a.dataHora.compareTo(b.dataHora)
          : b.dataHora.compareTo(a.dataHora);
    });
    return list;
  }

  List<Agenda> _aplicarFiltragem(List<Agenda> list) {
    if (_termo.isEmpty && _startDate == null && _endDate == null) {
      return list;
    } else {
      final String consulta = _termo.toLowerCase();
      return list.where((agenda) {
        final agendaDataHora = DateTime.parse(agenda.dataHora!);
        final inRange = (_startDate == null || _startDate!.isBefore(agendaDataHora)) &&
            (_endDate == null || _endDate!.isAfter(agendaDataHora));

        return (agenda.titulo.toLowerCase().contains(consulta) ||
            (agenda.descricao != null &&
                agenda.descricao!.toLowerCase().contains(consulta))) &&
            inRange;
      }).toList();
    }
  }
}

class _PesquisaAgenda extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final AgendaRepository agendaRepository =
    Provider.of<AgendaRepository>(context, listen: false);
    Future<List<Agenda>> futureList = agendaRepository.getEventos();

    return FutureBuilder<List<Agenda>>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Agenda> list = snapshot.data!;
          final List<Agenda> filteredList = list.where((agenda) {
            return agenda.titulo.toLowerCase().contains(query.toLowerCase()) ||
                agenda.descricao!.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (ctx, i) => ListTile(
              title: Text(filteredList[i].titulo),
              onTap: () {
                close(context, filteredList[i].titulo);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final AgendaRepository agendaRepository =
    Provider.of<AgendaRepository>(context);
    Future<List<Agenda>> futureList = agendaRepository.getEventos();

    return FutureBuilder<List<Agenda>>(
      future: futureList,
      builder: (context, snapshot) {
        print('zzzzzzzzzzzzz');

        if (snapshot.hasData) {
          final List<Agenda> list = snapshot.data!;
          final List<Agenda> filteredList = list.where((agenda) {
            return agenda.titulo.toLowerCase().contains(query.toLowerCase()) ||
                agenda.descricao!.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (ctx, i) => ListTile(
              title: Text(filteredList[i].titulo),
              onTap: () {
                close(context, filteredList[i].titulo);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
