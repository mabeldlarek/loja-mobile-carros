import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/marca.dart';
import 'package:http/http.dart' as http;

class MarcaRepository with ChangeNotifier {
  static Database? db;
  static const table = 'marca';
  static const columnId = 'idMarca';
  static const columnNome = 'nome';
  static const columnImagem = 'imagem';
  static const apiUri = 'http://10.0.2.2:8080/api/marca';


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
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(marca.toMap())
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
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$i"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Marca.fromMap(parsed.first);
    }
  }

  Future<List<Marca>> getMarcas() async {
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    return parsed.map((map) => Marca.fromMap(map)).toList();
  }

  Future<List<String>> obterNomesMarcas() async {
    final List<Map<String, dynamic>> maps = json.decode(
        await http.read(Uri.parse(apiUri))
    );
    return List.generate(maps.length, (i) => maps[i]['idMarca']['nome'] as String);
  }

  Future<List<Map<String, dynamic>>> buscarMarcasCarro() async {
    return json.decode(
        await http.read(Uri.parse(apiUri))
    );
  }

  Future<void> removerMarca(int idMarca) async {
    await http.delete(Uri.parse("$apiUri?id=$idMarca"));
    notifyListeners();
  }

  Future<void> editarMarca(int id, String nome, String imagem) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Marca(
            idMarca: id,
            nome: nome,
            imagem: imagem
        ).toMap())
    );
    notifyListeners();
  }
}
