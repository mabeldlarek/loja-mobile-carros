import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/agenda.dart';
import '../data/session.dart';

class AgendaRepository with ChangeNotifier {
  static Database? db;
  static const table = 'agenda';
  static const columnIdAgenda = 'idAgenda';
  static const columnIdVendedor = 'idVendedor';
  static const columnTitulo = 'titulo';
  static const columnDescricao = 'descricao';
  static const columnDataHora = 'dataHora';

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
    final db = await database;
    final nextId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX($columnIdAgenda) + 1 FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table($columnIdAgenda, $columnIdVendedor, $columnTitulo, $columnDescricao, $columnDataHora) VALUES (?, ?, ?, ?, ?)',
      [
        nextId,
        agenda.idVendedor,
        agenda.titulo,
        agenda.descricao,
        agenda.dataHora,
      ],
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
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnIdAgenda,
          columnIdVendedor,
          columnTitulo,
          columnDescricao,
          columnDataHora
        ],
        where: '$columnIdAgenda = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Agenda.fromMap(maps.first);
    }
  }

  Future<List<Agenda>> getHomeEventos() async {
    try {
      final db = await database;
      final idVendedor = Session.id;
      print('aaaaaaaaaaaaaaaaaaaqui');
      print(idVendedor);
      final maps = await db.query(table,
          columns: [
            columnIdAgenda,
            columnIdVendedor,
            columnTitulo,
            columnDescricao,
            columnDataHora
          ],
          where: '$columnIdVendedor = ?',
          whereArgs: [idVendedor],
          limit: 3,
          orderBy: '$columnDataHora desc');

      notifyListeners();
      return maps.map((map) => Agenda.fromMap(map)).toList();
    } catch (e) {
      print('Erro na obtenção dos eventos na home: $e');
      return [];
    }
  }

  Future<List<Agenda>> getEventos() async {
    try {
      final db = await database;
      final idVendedor = Session.id;

      final maps = await db.query(table,
          columns: [
            columnIdAgenda,
            columnIdVendedor,
            columnTitulo,
            columnDescricao,
            columnDataHora
          ],
          where: '$columnIdVendedor = ?',
          whereArgs: [idVendedor],
          orderBy: '$columnDataHora desc');
      notifyListeners();
      return maps.map((map) => Agenda.fromMap(map)).toList();
    } catch (e) {
      print('Erro na obtenção da listagem de eventos: $e');
      return [];
    }
  }

  Future<void> removerAgenda(int idAgenda) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnIdAgenda = ?',
      [idAgenda],
    );

    notifyListeners();
  }

  Future<void> editarAgenda(
      int id, String titulo, String descricao, String dataHora) async {
    final db = await database;

    final rowsAffected = await db.rawUpdate('''
    UPDATE $table 
    SET $columnTitulo = ?, 
    $columnDescricao = ?,
    $columnDataHora = ?
    WHERE idAgenda = ?
''', [titulo, descricao, dataHora, id]);

    notifyListeners();
  }
}
