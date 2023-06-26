import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/repository/promocao_repository.dart';
import 'package:http/http.dart' as http;

import '../data/database_helper.dart';
import '../model/veiculo.dart';
import '../utils/RealCurrencyInputFormatter.dart';

class VeiculoRepository with ChangeNotifier {
  static Database? db;
  static const table = 'veiculo';
  static const columnId = 'idVeiculo';
  static const columnIdModelo = 'idModelo';
  static const columnIdFornecedor = 'idFornecedor';
  static const columnValor = 'valor';
  static const columnTipo = 'tipo';
  static const columnCor = 'cor';
  static const columnPlaca = 'placa';
  static const apiUri = 'http://10.0.2.2:8080/api/veiculo';
  late String descricao = '';

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
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIdModelo INTEGER,
        $columnIdFornecedor INTEGER,
        $columnValor REAL,
        $columnTipo TEXT NOT NULL,
        $columnCor TEXT NOT NULL,
        $columnPlaca TEXT NOT NULL,
      )
      ''');
  }

  void insertVeiculo(Veiculo veiculo) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(veiculo.toMap())
    );
    notifyListeners();
    print(veiculo.toMap());
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
    final maps = await db!.query(table, columns: [columnId]);
    return maps.length;
  }

  Future<Veiculo?> byIndex(int i) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$i"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Veiculo.fromMap(parsed.first);
    }
  }

  Future<String?> obterDescricaoVeiculo(Veiculo veiculo) async {
    String? dadosString;
    int idModelo = veiculo.idModelo!;

    final List resultado = json.decode(
        await http.read(Uri.parse("$apiUri/descricao?id=$idModelo"))
    );

    final promocao = await PromocaoRepository().byVeiculo(veiculo.idVeiculo!);
    final valorVeiculo =
        RealCurrencyInputFormatter().formatCurrency(veiculo.valor);
    String valor = promocao != null
        ? 'Valor Promocional de: $valorVeiculo por: ${RealCurrencyInputFormatter().formatCurrency(promocao.valor)}'
        : valorVeiculo;

    for (var row in resultado) {
      dadosString =
          '${row['nome_marca']} / ${row['nome_modelo']} - ${row['ano']}\n$valor';
    }
    return dadosString;
  }

  Future<List<Veiculo>> getVeiculos() async {
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    print(parsed.toString());
    return parsed.map((map) => Veiculo.fromMap(map)).toList();
  }

  Future<void> removerVeiculo(int idVeiculo) async {
    await http.delete(Uri.parse("$apiUri?id=$idVeiculo"));
    notifyListeners();
  }

  Future<void> editarVeiculo(
      idVeiculo, idModelo, idFornecedor, valor, tipo, cor, placa) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Veiculo(
            idVeiculo: idVeiculo,
            idModelo: idModelo,
            idFornecedor: idFornecedor,
            valor: valor,
            tipo: tipo,
            cor: cor,
            placa: placa
        ).toMap())
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
