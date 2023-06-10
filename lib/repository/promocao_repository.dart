import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/repository/veiculo_repository.dart';

import '../model/promocao.dart';
import '../utils/RealCurrencyInputFormatter.dart';

class PromocaoRepository with ChangeNotifier {
  static Database? db;
  static final table = 'promocao';
  static final columnIdPromocao = 'idPromocao';
  static final columnIdVeiculo = 'idVeiculo';
  static final columnDataInicial = 'dataInicial';
  static final columnDataFinal = 'dataFinal';
  static final columnValor = 'valor';

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
        $columnIdPromocao INTEGER PRIMARY KEY,

      )
      ''');
  }

  void insertPromocao(Promocao promocao) async {
    final db = await database;
    final nextId = Sqflite.firstIntValue(await db
        .rawQuery('SELECT MAX($columnIdPromocao) + 1 as last_id FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table(idPromocao, idVeiculo, dataInicial, dataFinal, valor) VALUES (?, ?, ?, ?, ?)',
      [
        nextId,
        promocao.idVeiculo,
        promocao.dataInicial,
        promocao.dataFinal,
        promocao.valor
      ],
    );
    notifyListeners();
    print(promocao.toMap());
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db!.query(table, columns: [columnIdPromocao]);
    return maps.length;
  }

  Future<Promocao?> byIndex(int id) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnDataFinal,
          columnDataInicial,
          columnValor,
          columnIdVeiculo
        ],
        where: '$columnIdPromocao = ?',
        whereArgs: [id]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Promocao.fromMap(maps.first);
    }
  }

  Future<Promocao?> byVeiculo(int idVeiculo) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnDataFinal,
          columnDataInicial,
          columnValor,
        ],
        where: '$columnIdVeiculo = ?',
        whereArgs: [idVeiculo]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Promocao.fromMap(maps.first);
    }
  }

  Future<List<Promocao>> getPromocaos() async {
    final db = await database;
    final maps = await db.query(table, columns: [
      columnIdPromocao,
      columnIdVeiculo,
      columnDataFinal,
      columnDataInicial,
      columnValor,
    ]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Promocao.fromMap(map)).toList();
  }

  Future<void> removerPromocao(int idPromocao) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnIdPromocao = ?',
      [idPromocao],
    );

    notifyListeners();
  }

  Future<String?> obterDescricaoPromocao(Promocao promocao) async {
    final db = await database;
    String? dadosString;
    final veiculo = await VeiculoRepository().byIndex(promocao.idVeiculo!);
    int idModelo = veiculo!.idModelo!;

    final List<Map<String, dynamic>> resultado = await db.rawQuery('''
    SELECT marca.nome AS nome_marca, modelo.nome AS nome_modelo, modelo.ano
    FROM modelo
    INNER JOIN marca ON modelo.idMarca = marca.idMarca
    WHERE modelo.idModelo = '$idModelo'
  ''');

    String valorVeiculo = RealCurrencyInputFormatter().formatCurrency(veiculo!.valor!);
    String valorPromocao = RealCurrencyInputFormatter().formatCurrency(promocao.valor!);

    for (var row in resultado) {
      dadosString =
          '${row['nome_marca']} / ${row['nome_modelo']} - ${row['ano']} \nDe $valorVeiculo por : $valorPromocao';
    }

    return dadosString;
  }

  Future<void> editarPromocao(
      dataFinal, dataInicial, valor, idVeiculo, idPromocao) async {
    final db = await database;

    final rowsAffected = await db.rawUpdate(
      'UPDATE $table SET dataInicial = ?, dataFinal = ?, valor = ?, idVeiculo = ? WHERE idPromocao = ?',
      [dataInicial, dataFinal, valor, idVeiculo, idPromocao],
    );
    notifyListeners();
  }
}
