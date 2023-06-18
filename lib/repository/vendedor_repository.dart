import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/vendedor.dart';

import '../data/session.dart';

class VendedorRepository with ChangeNotifier {
  static Database? db;
  static final table = 'vendedor';
  static final columnIdVendedor = 'idVendedor';
  static final columnNome = 'nome';
  static final columnCPF = 'cpf';
  static final columnDataNascimento = 'dataNascimento';
  static final columnEmail = 'email';
  static final columnSenha = 'senha';

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
    final db = await database;
    final cnt = await count;
    if(cnt == 0) {
      final nextId = Sqflite.firstIntValue(
          await db.rawQuery('SELECT MAX($columnIdVendedor) + 1 FROM $table'));
      await db.rawInsert(
        'INSERT INTO $table($columnIdVendedor, $columnNome, $columnDataNascimento, $columnCPF, $columnEmail, $columnSenha) VALUES (?, ?, ?, ?, ?, ?)',
        [
          nextId,
          "admin",
          "2000-05-11T00:00:00.000",
          "132.279.959-80",
          "admin@mail.com",
          "123123",
        ],
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
    final db = await database;
    final nextId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX($columnIdVendedor) + 1 FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table($columnIdVendedor, $columnNome, $columnDataNascimento, $columnCPF, $columnEmail, $columnSenha) VALUES (?, ?, ?, ?, ?, ?)',
      [
        nextId,
        vendedor.nome,
        vendedor.dataNascimento,
        vendedor.cpf,
        vendedor.email,
        vendedor.senha,
      ],
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
    final maps = await db!.query(table, columns: [columnIdVendedor, columnNome]);
    return maps.length;
  }

  Future<Vendedor?> byIndex(int i) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnIdVendedor,
          columnNome,
          columnCPF,
          columnDataNascimento
        ],
        where: '$columnIdVendedor = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Vendedor.fromMap(maps.first);
    }
  }

  Future<List<Vendedor>> getVendedors() async {
    final db = await database;
    final maps = await db.query(table, columns: [
      columnIdVendedor,
      columnNome,
      columnCPF,
      columnDataNascimento,
      columnEmail,
      columnSenha
    ]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Vendedor.fromMap(map)).toList();
  }

  Future<void> removerVendedor(int idVendedor) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnIdVendedor = ?',
      [idVendedor],
    );

    notifyListeners();
  }

  Future<Vendedor?> obterVendedorPorId(int? idVendedor) async {
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnIdVendedor,
          columnNome,
          columnCPF,
          columnDataNascimento,
          columnEmail,
          columnSenha
        ],
        where: '$columnIdVendedor = ?',
        whereArgs: [idVendedor]);
    notifyListeners();
    if (maps.isEmpty) {
      return null;
    } else {
      return Vendedor.fromMap(maps.first);
    }
  }

  Future<void> editarVendedor(int id, String nome, String dataNascimento, String CPF, String email, String senha) async {
    final db = await database;
    print('$id vai ser editado');

    final rowsAffected = await db.rawUpdate(
      'UPDATE $table SET $columnNome = ?, $columnDataNascimento = ?, $columnCPF = ?, $columnEmail = ?, $columnSenha = ? WHERE idVendedor = ?',
    [nome, dataNascimento, CPF, email, senha, id]);

    print('Rows affected: $rowsAffected');
    notifyListeners();
  }

  Future<int> getLogin(String? email, String? senha) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
    await db.rawQuery(''
        'SELECT nome, $columnIdVendedor '
        'FROM vendedor v '
        'WHERE v.email = ? '
        'AND v.senha = ?;',
    [email, senha]);

    if(maps.isEmpty) {
      return -1;
    } else {
      Session.nome = maps[0]['nome'];
      Session.id = maps[0][columnIdVendedor];
      print(Session.id);
      return maps[0]['nome'] == 'admin' ? 1 : 2;
    }
  }
}
