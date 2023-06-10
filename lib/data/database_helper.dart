import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final String _databaseName = 'my_database11.db';
  static final int _databaseVersion = 1;

  DatabaseHelper._internal() {
    // if (_database == null) database;
  }
  static final DatabaseHelper instance = DatabaseHelper._internal();

  /// sqflite datbase instance
  static Database? _database;

  /// gets database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// initialize the database
  Future<Database> _initDB() async {
    print('createing databse');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    print('path is $path');
    return await openDatabase(path, version: 5, onCreate: (db, version) async {
      await db.execute(
          '''
      CREATE TABLE modelo(
          idModelo INTEGER PRIMARY KEY,
          nome TEXT,
          idMarca INTEGER,
          ano TEXT,
          codigoFipe TEXT,
          numPortas INTEGER,
          numAssentos INTEGER,
          quilometragem REAL,
          possuiAr TEXT
      )
    ''');

      await db.execute(
          '''
        CREATE TABLE marca (
          idMarca INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          imagem TEXT NOT NULL
        )
      ''');

      await db.execute(
          '''
        CREATE TABLE veiculo (
          idVeiculo INTEGER PRIMARY KEY AUTOINCREMENT,
          idModelo INTEGER,
          idFornecedor INTEGER,
          valor REAL,
          tipo TEXT NOT NULL,
          cor TEXT NOT NULL,
          placa TEXT NOT NULL
      )
   ''');

      await db.execute(
          '''
        CREATE TABLE cliente (
          idCliente INTEGER PRIMARY KEY,
          nome TEXT,
          email TEXT,
          celular TEXT,
          cpf TEXT,
          cnpj TEXT,
          dataNascimento TEXT,
          tipo TEXT
      )
   ''');

      await db.execute(
          '''
        CREATE TABLE vendedor (
            idVendedor INTEGER PRIMARY KEY,
            nome TEXT,
            cpf TEXT,
            dataNascimento TEXT,  
            email TEXT,
            senha TEXT
      )
   ''');

      await db.execute(
          '''
        CREATE TABLE venda (
            idVenda INTEGER PRIMARY KEY,
            idVeiculo INTEGER,
            idCliente INTEGER,
            idVendedor INTEGER,
            entrada REAL,
            parcelas INTEGER,
            data TEXT
      )
   ''');

      await db.execute(
          '''
        CREATE TABLE promocao (
        idPromocao INTEGER PRIMARY KEY,
        idVeiculo INTEGER,
        dataInicial TEXT,
        dataFinal TEXT,   
        valor REAL
      )
   ''');
    });
  }

  void limparTabela() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, _databaseName);

    Database database = await openDatabase(databasePath);

    String tabela = 'venda';

    await database.rawDelete('DELETE FROM $tabela');

    await database.close();
  }

  String get dataBaseName {
    return _databaseName;
  }

  int get versionDataBase {
    return _databaseVersion;
  }

  Future<bool> deleteDb() async {
    bool databaseDeleted = false;

    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      await deleteDatabase(path).whenComplete(() {
        databaseDeleted = true;
      }).catchError((onError) {
        databaseDeleted = false;
      });
    } on DatabaseException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }

    return databaseDeleted;
  }
}
