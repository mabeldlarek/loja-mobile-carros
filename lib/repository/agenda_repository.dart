import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/agenda.dart';
import '../data/session.dart';
import 'package:http/http.dart' as http;

class AgendaRepository with ChangeNotifier {
  static Database? db;
  static const table = 'agenda';
  static const columnIdAgenda = 'idAgenda';
  static const columnIdVendedor = 'idVendedor';
  static const columnTitulo = 'titulo';
  static const columnDescricao = 'descricao';
  static const columnDataHora = 'dataHora';
  static const apiUri = 'http://10.0.2.2:8080/api/agenda';

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDatabase();
    return db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseHelper.instance.dataBaseName);
    return await openDatabase(path,
        version: DatabaseHelper.instance.versionDataBase, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
         $columnIdAgenda INTEGER PRIMARY KEY,
         $columnIdVendedor INTEGER,
         $columnTitulo TEXT,
         $columnDescricao TEXT,
         $columnDataHora TEXT,
      )
      ''');
  }

  void insertAgenda(Agenda agenda) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(agenda.toMap())
    );
    notifyListeners();
    print(agenda.toMap());
  }

  Future<int> getProxId() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT MAX($columnIdAgenda) + 1 as last_id FROM $table');
    return maps.isNotEmpty ? maps[0]['last_id'] + 1 : 0 + 1;
  }

  Future<int> get count async {
    final db = await database;
    final maps =
        await db!.query(table, columns: [columnIdAgenda, columnTitulo]);
    return maps.length;
  }

  Future<Agenda?> byIndex(int i) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$i"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Agenda.fromMap(parsed.first);
    }
  }

  Future<List<Agenda>> getHomeEventos() async {
    try {
      final List maps = json.decode(
          await http.read(Uri.parse("$apiUri?idVendedor=${Session.id}&limit=true"))
      );

      notifyListeners();
      return maps.map((map) => Agenda.fromMap(map)).toList();
    } catch (e) {
      print('Erro na obtenção dos eventos na home: $e');
      return [];
    }
  }

  Future<List<Agenda>> getEventos() async {
    try {
      final maps = json.decode(
          await http.read(Uri.parse("$apiUri?idVendedor=${Session.id}&limit=false"))
      );
      notifyListeners();
      return maps.map((map) => Agenda.fromMap(map)).toList();
    } catch (e) {
      print('Erro na obtenção da listagem de eventos: $e');
      return [];
    }
  }

  Future<void> removerAgenda(int idAgenda) async {
    await http.delete(Uri.parse("$apiUri?id=$idAgenda"));
    notifyListeners();
  }

  Future<void> editarAgenda(
      int id, String titulo, String descricao, String dataHora) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Agenda(
          idAgenda: id,
          idVendedor: Session.id!,
          titulo: titulo,
          descricao: descricao,
          dataHora: dataHora,
        ).toMap())
    );
    notifyListeners();
  }
}
