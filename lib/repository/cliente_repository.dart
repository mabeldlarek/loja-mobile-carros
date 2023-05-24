import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/cliente.dart';

class ClienteRepository with ChangeNotifier {
  static Database? db;
  static final table = 'cliente';
  static final columnIdCliente = 'idCliente';
  static final columnNome = 'nome';
  static final columnEmail = 'email';
  static final columnCelular = 'celular';
  static final columnCPF = 'cpf';
  static final columnCNPJ = 'cnpj';
  static final columnDataNascimento = 'dataNascimento';
  static final columnTipo = 'tipo';

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
    final db = await database;
    final nextId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX($columnIdCliente) + 1 FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table($columnIdCliente, $columnNome, $columnEmail, $columnCelular, $columnCPF, $columnCNPJ, $columnTipo, $columnDataNascimento) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        nextId,
        cliente.nome,
        cliente.email,
        cliente.celular,
        cliente.cpf,
        cliente.cnpj,
        cliente.tipo,
        cliente.dataNascimento
      ],
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
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnIdCliente,
          columnNome,
          columnEmail,
          columnCelular,
          columnCPF,
          columnCNPJ,
          columnDataNascimento,
          columnTipo,
        ],
        where: '$columnIdCliente = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Cliente.fromMap(maps.first);
    }
  }

  Future<List<Cliente>> getClientes() async {
    final db = await database;
    final maps = await db.query(table, columns: [
      columnIdCliente,
      columnNome,
      columnEmail,
      columnCelular,
      columnCPF,
      columnCNPJ,
      columnDataNascimento,
      columnTipo,
    ]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Cliente.fromMap(map)).toList();
  }

    Future<List<Cliente>> getClientesFornecedores() async {
    final db = await database;

    final maps = await db.rawQuery(
      "SELECT * FROM cliente WHERE tipo = 'FORNECEDOR'");

    notifyListeners();
    print(maps.length);
    return maps.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<void> removerCliente(int idCliente) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnIdCliente = ?',
      [idCliente],
    );

    notifyListeners();
  }

  Future<void> editarCliente(int id, String nome, String email, String celular, String CPF, String CNPJ, String dataNascimento, String tipo) async {
    final db = await database;
    print('$id vai ser editado');

    final rowsAffected = await db.rawUpdate('''
    UPDATE $table 
    SET $columnNome = ?, 
    $columnEmail = ?, 
    $columnCelular = ?,
    $columnCPF = ?,
    $columnCNPJ = ?,
    $columnDataNascimento = ?,
    $columnTipo = ?
    WHERE idCliente = ?
''', [nome, email, celular, CPF, CNPJ, dataNascimento, tipo, id]);

    print('Rows affected: $rowsAffected');
    notifyListeners();
  }
}
