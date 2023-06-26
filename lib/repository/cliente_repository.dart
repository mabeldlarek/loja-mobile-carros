import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/cliente.dart';
import 'package:http/http.dart' as http;

class ClienteRepository with ChangeNotifier {
  static Database? db;
  static const table = 'cliente';
  static const columnIdCliente = 'idCliente';
  static const columnNome = 'nome';
  static const columnEmail = 'email';
  static const columnCelular = 'celular';
  static const columnCPF = 'cpf';
  static const columnCNPJ = 'cnpj';
  static const columnDataNascimento = 'dataNascimento';
  static const columnTipo = 'tipo';
  static const apiUri = 'http://10.0.2.2:8080/api/cliente';

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
    await db.execute(
        '''
      CREATE TABLE $table (
         $columnIdCliente INTEGER PRIMARY KEY,
            $columnNome TEXT,
            $columnEmail TEXT,
            $columnCelular TEXT,
            $columnCPF TEXT,
            $columnCNPJ TEXT,
            $columnDataNascimento TEXT,
            $columnTipo TEXT
      )
      ''');
  }

  void insertCliente(Cliente cliente) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(cliente.toMap())
    );
    notifyListeners();
    print(cliente.toMap());
  }

  Future<int> getProxId() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT MAX($columnIdCliente) + 1 as last_id FROM $table');
    return maps.isNotEmpty ? maps[0]['last_id'] + 1 : 0 + 1;
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db!.query(table, columns: [columnIdCliente, columnNome]);
    return maps.length;
  }

  Future<Cliente?> byIndex(int i) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$i"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Cliente.fromMap(parsed.first);
    }
  }

  Future<List<Cliente>> getClientes() async {
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    return parsed.map((map) => Cliente.fromMap(map)).toList();
  }

    Future<List<Cliente>> getClientesFornecedores() async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?tipo=FORNECEDOR"))
    );
    notifyListeners();
    return parsed.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<void> removerCliente(int idCliente) async {
    await http.delete(Uri.parse("$apiUri?id=$idCliente"));
    notifyListeners();
  }

  Future<void> editarCliente(int id, String nome, String email, String celular, String cpf, String cnpj, String dataNascimento, String tipo) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Cliente(
            idCliente: id,
            nome: nome,
            cpf: cpf,
            cnpj: cnpj,
            email: email,
            celular: celular,
            dataNascimento: dataNascimento,
            tipo: tipo
        ).toMap())
    );
    notifyListeners();
  }
}
