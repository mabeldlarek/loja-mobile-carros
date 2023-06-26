import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/model/venda.dart';
import 'package:vendas_veiculos/repository/veiculo_repository.dart';
import 'package:http/http.dart' as http;

import '../model/veiculo.dart';

class VendaRepository with ChangeNotifier {
  static Database? db;
  static const table = 'venda';
  static const columnIdVenda = 'idVenda';
  static const columnIdVeiculo = 'idVeiculo';
  static const columnIdCliente = 'idCliente';
  static const columnIdVendedor = 'idVendedor';
  static const columnEntrada = 'entrada';
  static const columnParcelas = 'parcelas';
  static const columnData = 'data';
  static const apiUri = 'http://10.0.2.2:8080/api/venda';

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
         $columnIdVenda INTEGER PRIMARY KEY,
            $columnIdVeiculo INTEGER,
            $columnIdCliente INTEGER,
            $columnIdVendedor INTEGER,
            $columnEntrada REAL,
            $columnParcelas INTEGER,
            $columnData TEXT,
      )
      ''');
  }

  void insertVenda(Venda venda) async {
    print("request");
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(venda.toMap())
    );
    notifyListeners();
    print(venda.toMap());
  }

  Future<int> getProxId() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT last_insert_rowid() as last_id');
    return maps.isNotEmpty ? maps[0]['last_id'] + 1 : 0 + 1;
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db!.query(table, columns: [columnIdVenda]);
    return maps.length;
  }

  Future<Venda?> byIndex(int i) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$i"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Venda.fromMap(parsed.first);
    }
  }

  Future<String?> obterDescricaoVenda(Venda venda) async {
    int idVeiculo = venda.idVeiculo!;
    Veiculo? veiculo = await VeiculoRepository().byIndex(idVeiculo);
    String? descricaoVeiculo =
        await VeiculoRepository().obterDescricaoVeiculo(veiculo!);
    DateTime dataFormatada = DateFormat('yyyy-MM-dd').parse(venda.data!);
    String data = DateFormat('dd/MM/yyyy').format(dataFormatada);

    return data + ' - ' + descricaoVeiculo!;
  }

  Future<bool?> byVeiculo(int i) async {
    final maps = json.decode(
        await http.read(Uri.parse("$apiUri?idVeiculo=$i"))
    );
    if (maps.isEmpty) {
      return false; //não há vendas
    } else {
      return true;
    }
  }

  Future<List<Venda>> getVendas() async {
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    return parsed.map((map) => Venda.fromMap(map)).toList();
  }

  Future<void> removerVenda(int idVenda) async {
    await http.delete(Uri.parse("$apiUri?id=$idVenda"));
    notifyListeners();
  }

  Future<void> editarVenda(int idVenda, int idVeiculo, int idVendedor, int idCliente,
      double entrada, int parcela, String data) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Venda(
            idVenda: idVenda,
            idVeiculo: idVeiculo,
            idCliente: idCliente,
            idVendedor: idVendedor,
            entrada: entrada,
            parcelas: parcela,
            data: data,
        ).toMap())
    );
    notifyListeners();
  }
}
