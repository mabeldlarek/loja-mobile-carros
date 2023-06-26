import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/vendedor.dart';
import 'package:http/http.dart' as http;

import '../data/session.dart';

class VendedorRepository with ChangeNotifier {
  static Database? db;
  static const table = 'vendedor';
  static const columnIdVendedor = 'idVendedor';
  static const columnNome = 'nome';
  static const columnCPF = 'cpf';
  static const columnDataNascimento = 'dataNascimento';
  static const columnEmail = 'email';
  static const columnSenha = 'senha';
  static const apiUri = 'http://10.0.2.2:8080/api/vendedor';

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

  Future<void> seed() async {
    final List cnt = json.decode(await http.read(Uri.parse(apiUri)));
    if(cnt.isEmpty) {

      await http.put(Uri.parse(apiUri),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: json.encode(Vendedor(
              nome: 'admin',
              cpf: '132.279.959-80',
              dataNascimento: '2000-05-11T00:00:00.000',
              email: 'admin@mail.com',
              senha: '123123').toMap()
          )
      );

      await http.put(Uri.parse(apiUri),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: json.encode(Vendedor(
              nome: 'vendedor',
              cpf: '516.433.090-30',
              dataNascimento: '2000-05-11T00:00:00.000',
              email: 'vendedor@mail.com',
              senha: '123123').toMap()
          )
      );

      print("vendedor seeded");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE $table (
         $columnIdVendedor INTEGER PRIMARY KEY,
            $columnNome TEXT,
            $columnIdVendedor INTEGER,
            $columnNome TEXT,
            $columnCPF TEXT,
            $columnDataNascimento TEXT,  
            $columnEmail TEXT,
            $columnSenha TEXT,  
      ''');
  }

  void insertVendedor(Vendedor vendedor) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(vendedor.toMap())
    );
    notifyListeners();
    print(vendedor.toMap());
  }

  Future<int> getProxId() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT last_insert_rowid() as last_id');
    return maps.isNotEmpty ? maps[0]['last_id'] + 1 : 0 + 1;
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db.query(table, columns: [columnIdVendedor, columnNome]);
    return maps.length;
  }

  Future<Vendedor?> byIndex(int i) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$i"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Vendedor.fromMap(parsed.first);
    }
  }

  Future<List<Vendedor>> getVendedors() async {
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    return parsed.map((map) => Vendedor.fromMap(map)).toList();
  }

  Future<void> removerVendedor(int idVendedor) async {
    await http.delete(Uri.parse("$apiUri?id=$idVendedor"));
    notifyListeners();
  }

  Future<Vendedor?> obterVendedorPorId(int? idVendedor) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$idVendedor"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Vendedor.fromMap(parsed.first);
    }
  }

  Future<void> editarVendedor(int id, String nome, String dataNascimento, String cpf, String email, String senha) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Vendedor(
            idVendedor: id,
            nome: nome,
            cpf: cpf,
            dataNascimento: dataNascimento,
            email: email,
            senha: senha
        ).toMap())
    );
    notifyListeners();
  }

  Future<int> getLogin(String? email, String? senha) async {
    final List<dynamic> maps = await json.decode(
        await http.read(Uri.parse("$apiUri?email=$email&senha=$senha"))
    );

    if(maps.isEmpty) {
      return -1;
    } else {
      Session.nome = maps[0][columnNome];
      Session.id = maps[0][columnIdVendedor];
      notifyListeners();
      return maps[0]['nome'] == 'admin' ? 1 : 2;
    }
  }
}
