import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/marca.dart';

class MarcaRepository with ChangeNotifier {
  static Database? db;
  static final table = 'marca';
  static final columnId = 'idMarca';
  static final columnNome = 'nome';
  static final columnImagem = 'imagem';

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDatabase();
    return db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseHelper.instance.dataBaseName);
    return await openDatabase(path, version: DatabaseHelper.instance.versionDataBase, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNome TEXT NOT NULL,
        $columnImagem TEXT NOT NULL
      )
      ''');
  }

  void insertMarca(Marca marca) async {
    final db = await database;
    final nextId = Sqflite.firstIntValue(await db.rawQuery('SELECT MAX($columnId) + 1 FROM $table'));
    //final imageBytes = await marca.imagem.readAsBytes();
    await db.rawInsert(
    'INSERT INTO $table(idMarca, nome, imagem) VALUES (?, ?, ?)',
    [nextId, marca.nome, marca.imagem],
    );

    notifyListeners();
    print(marca.toMap());
  }

  Future<int> getProxId() async {
    final Database db =
        await database; // `database` é uma função que retorna uma instância do banco de dados.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT last_insert_rowid() as last_id');
    return maps.isNotEmpty ? maps[0]['last_id'] + 1 : 0 + 1;
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db!.query(table, columns: [columnId, columnNome]);
    return maps.length;
  }

  Future<Marca?> byIndex(int i) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [columnId, columnNome, columnImagem],
        where: '$columnId = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Marca.fromMap(maps.first);
    }
  }

  Future<List<Marca>> getMarcas() async {
    final db = await database;
    final maps =
        await db.query(table, columns: [columnId, columnNome, columnImagem]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Marca.fromMap(map)).toList();
  }

  Future<List<String>> obterNomesMarcas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, columns: ['idMarca','nome']);
    return List.generate(maps.length, (i) => maps[i]['idMarca']['nome'] as String);
  }

  Future<List<Map<String, dynamic>>> buscarMarcasCarro() async {
  final db = await database;
  final marcas = await db.query(table, columns: ['idMarca','nome']);
  List<Map<String, dynamic>> listMarcas = await db.query(table, columns: ['idMarca','nome']);

  return listMarcas;
  }

  Future<void> removerMarca(int idMarca) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnId = ?',
      [idMarca],
    );

    notifyListeners();
  }

  Future<void> editarMarca(int id, String nome, String imagem) async {
    final db = await database;
    print('$id vai ser editado');

    final rowsAffected = await db.rawUpdate(
    'UPDATE $table SET nome = ?, imagem = ? WHERE idMarca = ?',
    [nome, imagem, id],
    );

    print('Rows affected: $rowsAffected');
    notifyListeners();
  }
}
