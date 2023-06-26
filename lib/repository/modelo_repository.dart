import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:http/http.dart' as http;

import '../model/modelo.dart';

class ModeloRepository with ChangeNotifier {
  static Database? db;
  static const table = 'modelo';
  static const columnIdModelo = 'idModelo';
  static const columnNome = 'nome';
  static const columnIdMarca = 'idMarca';
  static const columnAno = 'ano';
  static const columnCodFipe = 'codigoFipe';
  static const columnNumPorta = 'numPortas';
  static const columnNumAssento = 'numAssentos';
  static const columnQuilometragem = 'quilometragem';
  static const columnPossuiAr = 'possuiAr';
  static const apiUri = 'http://10.0.2.2:8080/api/modelo';
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
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(modelo.toMap())
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
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$id"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Modelo.fromMap(parsed.first);
    }
  }

  Future<String?> getDescricaoModelo(int idMarca) async {
    String? dadosString;

    final List<Map<String, dynamic>> resultado = json.decode(
        await http.read(Uri.parse("$apiUri/descricao?id=$idMarca"))
    );

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
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    notifyListeners();
    return parsed.map((map) => Modelo.fromMap(map)).toList();
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
    await http.delete(Uri.parse("$apiUri?id=$idModelo"));
    notifyListeners();
  }

  Future<void> editarModelo(nome, idMarca, idModelo, ano, codigoFipe, numPortas,
      numAssentos, quilometragem, possuiAr) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Modelo(
            nome: nome,
            idMarca: idMarca,
            idModelo: idModelo,
            ano: ano,
            codigoFipe: codigoFipe,
            numeroPortas: numPortas,
            numeroAssentos: numAssentos,
            quilometragem: quilometragem,
            possuiAr: possuiAr).toMap()
        )
    );
    notifyListeners();
  }

  _setDescricao(String descricao) {
    this.descricao = descricao;
  }

  String getDescricao() {
    return this.descricao;
  }
}
