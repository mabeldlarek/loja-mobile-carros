import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';

import '../model/modelo.dart';

class ModeloRepository with ChangeNotifier {
  static Database? db;
  static final table = 'modelo';
  static final columnIdModelo = 'idModelo';
  static final columnNome = 'nome';
  static final columnIdMarca = 'idMarca';
  static final columnAno = 'ano';
  static final columnCodFipe = 'codigoFipe';
  static final columnNumPorta = 'numPortas';
  static final columnNumAssento = 'numAssentos';
  static final columnQuilometragem = 'quilometragem';
  static final columnPossuiAr = 'possuiAr';
  late String descricao;

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
        $columnIdModelo INTEGER PRIMARY KEY,
        $columnNome TEXT,
        $columnIdMarca INTEGER,
        $columnAno TEXT,
        $columnCodFipe TEXT,
        $columnNumPorta INTEGER,
        $columnNumAssento INTEGER,
        $columnQuilometragem REAL,
        $columnPossuiAr TEXT
      )
      ''');
  }

  void insertModelo(Modelo modelo) async {
    final db = await database;
    final nextId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX($columnIdModelo) + 1 as last_id FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table(idModelo, nome, idMarca, ano, codigoFipe, numPortas, numAssentos, quilometragem, possuiAr) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        nextId,
        modelo.nome,
        modelo.idMarca,
        modelo.ano,
        modelo.codigoFipe,
        modelo.numPortas,
        modelo.numAssentos,
        modelo.quilometragem,
        modelo.possuiAr
      ],
    );
    notifyListeners();
    print(modelo.toMap());
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db!.query(table, columns: [columnIdModelo, columnNome]);
    return maps.length;
  }

  Future<Modelo?> byIndex(int id) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnNome,
          columnIdMarca,
          columnAno,
          columnCodFipe,
          columnNumPorta,
          columnNumAssento,
          columnQuilometragem,
          columnPossuiAr
        ],
        where: '$columnIdModelo = ?',
        whereArgs: [id]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Modelo.fromMap(maps.first);
    }
  }

  Future<String?> getDescricaoModelo(int idMarca) async {
    final db = await database;
    String? dadosString;

    final List<Map<String, dynamic>> resultado = await db.rawQuery('''
    SELECT marca.nome AS nome_marca, modelo.nome AS nome_modelo, modelo.ano
    FROM modelo
    INNER JOIN marca ON modelo.idMarca = marca.idMarca
    WHERE marca.idMarca = '$idMarca'
  ''');

    for (var row in resultado) {
      print('Marca: ${row['nome_marca']}');
      print('Modelo: ${row['nome_modelo']}');
      print('Ano: ${row['ano']}');

      dadosString =
      '${row['nome_marca']} / ${row['nome_modelo']} - ${row['ano']}';
    }

    return dadosString;
  }

  Future<List<Modelo>> getModelos() async {
    final db = await database;
    final maps = await db.query(table, columns: [
      columnIdModelo,
      columnIdMarca,
      columnNome,
      columnAno,
      columnCodFipe,
      columnNumPorta,
      columnNumAssento,
      columnQuilometragem,
      columnPossuiAr
    ]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Modelo.fromMap(map)).toList();
  }

  Future<List<Modelo>> getModelosFlitered(Map<String, String?> filtros) async {
    final db = await database;
    String whereString = "";
    List<String> whereValues = [];

    filtros.forEach((key, value) {
      if (value != null && value.isNotEmpty && value != 'null') {
        whereString = "$whereString$key = ? AND ";
        whereValues.add(value);
      }
    });

    whereString = whereString.substring(0, whereString.length - 5);

    print("$whereString | $whereValues");

    final maps = await db.query(table, columns: [
      columnIdModelo,
      columnIdMarca,
      columnNome,
      columnAno,
      columnCodFipe,
      columnNumPorta,
      columnNumAssento,
      columnQuilometragem,
      columnPossuiAr
    ],
        where: whereString,
        whereArgs: whereValues
    );
    notifyListeners();
    print(maps);
    return maps.map((map) => Modelo.fromMap(map)).toList();
  }

  Future<void> removerModelo(int idModelo) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnIdModelo = ?',
      [idModelo],
    );

    notifyListeners();
  }

  Future<void> editarModelo(nome, idMarca, idModelo, ano, codigoFipe, numPortas,
      numAssentos, quilometragem, possuiAr) async {
    final db = await database;

    final rowsAffected = await db.rawUpdate(
      'UPDATE $table SET nome = ?, idMarca = ?, ano = ?, codigoFipe = ?, numPortas = ?, numAssentos = ?, quilometragem = ?, possuiAr = ? WHERE idModelo = ?',
      [
        nome,
        idMarca,
        ano,
        codigoFipe,
        numPortas,
        numAssentos,
        quilometragem,
        possuiAr,
        idModelo
      ],
    );

    print('Rows affected: $rowsAffected');
    notifyListeners();
  }

  _setDescricao(String descricao) {
    this.descricao = descricao;
  }

  String getDescricao() {
    return this.descricao;
  }
}
