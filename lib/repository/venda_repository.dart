import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/venda.dart';

class VendaRepository with ChangeNotifier {
  static Database? db;
  static final table = 'venda';
  static final columnIdVenda = 'idVenda';
  static final columnIdVeiculo = 'idVeiculo';
  static final columnIdCliente = 'idCliente';
  static final columnIdVendedor = 'idVendedor';
  static final columnEntrada = 'entrada';
  static final columnParcelas = 'parcelas';
  static final columnData = 'data';

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
         $columnIdVenda INTEGER PRIMARY KEY,
            $columnIdVeiculo INTEGER,
            $columnIdCliente INTEGER,
            $columnIdVendedor INTEGER,
            $columnEntrada REAL,
            $columnParcelas INTEGER,
            $columnData TEXT,
      )
      ''');
  }

  void insertVenda(Venda venda) async {
    final db = await database;
    final nextId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX($columnIdVenda) + 1 as last_id FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table($columnIdVenda, $columnIdVeiculo, $columnIdCliente, $columnIdVendedor, $columnEntrada, $columnParcelas, $columnData) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        nextId,
        venda.idVeiculo,
        venda.idCliente,
        venda.idVendedor,
        venda.entrada,
        venda.parcelas,
        venda.data,
      ],
    );

    notifyListeners();
    print(venda.toMap());
  }

  Future<int> getProxId() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT last_insert_rowid() as last_id');
    return maps.isNotEmpty ? maps[0]['last_id'] + 1 : 0 + 1;
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db!.query(table, columns: [columnIdVenda]);
    return maps.length;
  }

  Future<Venda?> byIndex(int i) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnIdVenda,
          columnIdCliente,
          columnIdVeiculo,
          columnIdVendedor,
          columnEntrada,
          columnParcelas,
          columnData,
        ],
        where: '$columnIdVenda = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Venda.fromMap(maps.first);
    }
  }

   Future<Venda?> byVeiculo(int i) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnIdVenda,
        ],
        where: '$columnIdVeiculo = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Venda.fromMap(maps.first);
    }
  }

  Future<List<Venda>> getVendas() async {
    final db = await database;
    final maps = await db.query(table, columns: [
      columnIdVenda,
      columnIdCliente,
      columnIdVeiculo,
      columnIdVendedor,
      columnEntrada,
      columnParcelas,
      columnData,
    ]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Venda.fromMap(map)).toList();
  }

  Future<void> removerVenda(int idVenda) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnIdVenda = ?',
      [idVenda],
    );

    notifyListeners();
  }

  Future<void> editarVenda(int idVenda, int idVeiculo, int idCliente,
      double entrada, int parcela) async {
    final db = await database;

     final rowsAffected = await db.rawUpdate(
      'UPDATE $table SET idVeiculo = ?, idCliente = ?, entrada = ?, parcelas = ? WHERE idVenda = ?',
      [idVeiculo, idCliente, entrada, parcela, idVenda],
    );

    print('Rows affected: $rowsAffected');
    notifyListeners();
  }
}
