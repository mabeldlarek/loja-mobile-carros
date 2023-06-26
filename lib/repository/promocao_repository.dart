import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/data/database_helper.dart';
import 'package:vendas_veiculos/repository/veiculo_repository.dart';
import 'package:http/http.dart' as http;

import '../model/promocao.dart';
import '../utils/RealCurrencyInputFormatter.dart';

class PromocaoRepository with ChangeNotifier {
  static Database? db;
  static final table = 'promocao';
  static const columnIdPromocao = 'idPromocao';
  static const columnIdVeiculo = 'idVeiculo';
  static const columnDataInicial = 'dataInicial';
  static const columnDataFinal = 'dataFinal';
  static const columnValor = 'valor';
  static const apiUri = 'http://10.0.2.2:8080/api/promocao';

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
        $columnIdPromocao INTEGER PRIMARY KEY,

      )
      ''');
  }

  void insertPromocao(Promocao promocao) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(promocao.toMap())
    );
    notifyListeners();
    print(promocao.toMap());
  }

  Future<int> get count async {
    final db = await database;
    final maps = await db.query(table, columns: [columnIdPromocao]);
    return maps.length;
  }

  Future<Promocao?> byIndex(int id) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?id=$id"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Promocao.fromMap(parsed.first);
    }
  }

  Future<Promocao?> byVeiculo(int idVeiculo) async {
    final List parsed = json.decode(
        await http.read(Uri.parse("$apiUri?idVeiculo=$idVeiculo"))
    );
    if (parsed.isEmpty) {
      return null;
    } else {
      return Promocao.fromMap(parsed.first);
    }
  }

  Future<List<Promocao>> getPromocaos() async {
    final List parsed = json.decode(await http.read(Uri.parse(apiUri)));
    return parsed.map((map) => Promocao.fromMap(map)).toList();
  }

  Future<void> removerPromocao(int idPromocao) async {
    await http.delete(Uri.parse("$apiUri?id=$idPromocao"));
    notifyListeners();
  }

  Future<String?> obterDescricaoPromocao(Promocao promocao) async {
    String? dadosString;
    final veiculo = await VeiculoRepository().byIndex(promocao.idVeiculo!);
    int idModelo = veiculo!.idModelo!;

    final List resultado = json.decode(
        await http.read(Uri.parse("$apiUri/descricao?id=$idModelo"))
    );

    String valorVeiculo = RealCurrencyInputFormatter().formatCurrency(veiculo.valor);
    String valorPromocao = RealCurrencyInputFormatter().formatCurrency(promocao.valor);

    for (var row in resultado) {
      dadosString =
          '${row['nome_marca']} / ${row['nome_modelo']} - ${row['ano']} \nDe $valorVeiculo por : $valorPromocao';
    }

    return dadosString;
  }

  Future<void> editarPromocao(
      dataFinal, dataInicial, valor, idVeiculo, idPromocao) async {
    await http.put(Uri.parse(apiUri),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(Promocao(
            idVeiculo: idVeiculo,
            valor: valor,
            dataFinal: dataFinal,
            dataInicial: dataInicial
        ).toMap())
    );
    notifyListeners();
  }
}
