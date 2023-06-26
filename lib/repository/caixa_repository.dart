import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/repository/venda_repository.dart';

import '../data/database_helper.dart';
import '../model/venda.dart';

class CaixaRepository with ChangeNotifier {
  static Database? db;
  static const table = 'venda';

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDatabase();
    return db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseHelper.instance.dataBaseName);
    return await openDatabase(path,
        version: DatabaseHelper.instance.versionDataBase, onCreate: null);
  }

  Future<List<Venda>> getVendas() async {
    return VendaRepository().getVendas();
  }
}
