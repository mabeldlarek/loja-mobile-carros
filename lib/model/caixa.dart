import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Future<List<Map<String, dynamic>>> getSales() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database11.db');
    
    // Verifica se o banco de dados existe
    if (!await databaseExists(path)) {
      // Cria o banco de dados e as tabelas
      final database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // Cria a tabela "venda"
          await db.execute('''
            CREATE TABLE venda (
              idVenda INTEGER PRIMARY KEY,
              cliente TEXT,
              vendedor TEXT,
              valor REAL
            )
          ''');
        }
      );
      
      await database.close();
      
      return [];
    }
    
    final database = await openDatabase(path);

    final result = await database.rawQuery('SELECT * FROM venda');
    await database.close();

    return result;
  }
}

class CaixaPage extends StatelessWidget {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Módulo Financeiro'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseHelper.getSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as vendas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Não há vendas disponíveis'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final venda = snapshot.data![index];
                final cliente = venda['cliente'];
                final vendedor = venda['vendedor'];
                final valor = venda['valor'] ?? 0; // Valor padrão de 0 caso não exista

                return ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Venda ${venda['idVenda']}'),
                  subtitle: Text('Cliente: $cliente | Vendedor: $vendedor'),
                  trailing: Text('R\$ $valor'),
                  onTap: () {
                    generateReceipt(context, venda);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void generateReceipt(BuildContext context, Map<String, dynamic> venda) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final cliente = venda['cliente'];
        final vendedor = venda['vendedor'];
        final valor = venda['valor'] ?? 0; // Valor padrão de 0 caso não exista

        return AlertDialog(
          title: Text('Recibo da Venda'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vendedor: $vendedor'),
              Text('Cliente: $cliente'),
              Text('Valor Total: R\$ $valor'),
              // Adicione mais informações do recibo conforme necessário
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
