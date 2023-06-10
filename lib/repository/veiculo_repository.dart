import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vendas_veiculos/repository/promocao_repository.dart';

import '../data/database_helper.dart';
import '../model/veiculo.dart';
import '../utils/RealCurrencyInputFormatter.dart';

class VeiculoRepository with ChangeNotifier {
  static Database? db;
  static final table = 'veiculo';
  static final columnId = 'idVeiculo';
  static final columnIdModelo = 'idModelo';
  static final columnIdFornecedor = 'idFornecedor';
  static final columnValor = 'valor';
  static final columnTipo = 'tipo';
  static final columnCor = 'cor';
  static final columnPlaca = 'placa';
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
    await db.execute(
        '''
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
    final db = await database;
    final nextId = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX($columnId) + 1 as last_id FROM $table'));
    await db.rawInsert(
      'INSERT INTO $table(${columnId}, ${columnIdModelo}, ${columnIdFornecedor}, ${columnValor}, ${columnTipo}, ${columnCor}, ${columnPlaca}) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        nextId,
        veiculo.idModelo,
        veiculo.idFornecedor,
        veiculo.valor,
        veiculo.tipo,
        veiculo.cor,
        veiculo.placa
      ],
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
    final db = await database;
    final maps = await db.query(table,
        columns: [
          columnId,
          columnIdModelo,
          columnIdFornecedor,
          columnValor,
          columnTipo,
          columnCor,
          columnPlaca
        ], //rever as necessárias
        where: '$columnId = ?',
        whereArgs: [i]);
    if (maps.isEmpty) {
      return null;
    } else {
      return Veiculo.fromMap(maps.first);
    }
  }

  Future<String?> obterDescricaoVeiculo(Veiculo veiculo) async {
    final db = await database;
    String? dadosString;
    int idModelo = veiculo.idModelo!;

    final List<Map<String, dynamic>> resultado = await db.rawQuery(
        '''
    SELECT marca.nome AS nome_marca, modelo.nome AS nome_modelo, modelo.ano
    FROM modelo
    INNER JOIN marca ON modelo.idMarca = marca.idMarca
    WHERE modelo.idModelo = '$idModelo'
  ''');

    final promocao = await PromocaoRepository().byVeiculo(veiculo.idVeiculo!);
    final valorVeiculo =
        RealCurrencyInputFormatter().formatCurrency(veiculo.valor);
    String valor = promocao != null
        ? 'Valor Promocional de: $valorVeiculo por: ' +
            RealCurrencyInputFormatter().formatCurrency(promocao.valor!)
        : valorVeiculo;

    for (var row in resultado) {
      dadosString =
          '${row['nome_marca']} / ${row['nome_modelo']} - ${row['ano']}\n$valor';
    }

    return dadosString;
  }

  Future<List<Veiculo>> getVeiculos() async {
    final db = await database;
    final maps = await db.query(table, columns: [
      columnId,
      columnIdModelo,
      columnIdFornecedor,
      columnValor,
      columnTipo,
      columnCor,
      columnPlaca
    ]);
    notifyListeners();
    print(maps.length);
    return maps.map((map) => Veiculo.fromMap(map)).toList();
  }

  Future<void> removerVeiculo(int idVeiculo) async {
    final db = await database;
    final rowsDeleted = await db.rawDelete(
      'DELETE FROM $table WHERE $columnId = ?',
      [idVeiculo],
    );

    notifyListeners();
  }

  Future<void> editarVeiculo(
      idVeiculo, idModelo, idFornecedor, valor, tipo, cor, placa) async {
    final db = await database;

    final rowsAffected = await db.rawUpdate(
      'UPDATE $table SET idModelo = ?, idFornecedor = ?, valor = ?, tipo = ?, cor = ?, placa = ? WHERE idVeiculo = ?',
      [idModelo, idFornecedor, valor, tipo, cor, placa, idVeiculo],
    );

    print('Rows affected: $rowsAffected');
    notifyListeners();
  }

  _setDescricao(String descricao) {
    this.descricao = descricao;
  }

  String getDescricao() {
    return this.descricao;
  }
}
