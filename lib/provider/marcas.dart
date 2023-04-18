import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vendas_veiculos/data/marcas.dart';

import '../model/marca.dart';

class Marcas with ChangeNotifier {
  final Map<String, Marca> _itens = {...MARCAS};

  List<Marca> get all {
    return [..._itens.values];
  }

  int get count {
    return _itens.length;
  }

  Marca byIndex(int i) {
    return _itens.values.elementAt(i);
  }

  void put(Marca marca) {
    if (marca == null) {
      return;
    }

    if (marca.id != null &&
        marca.id!.trim().isNotEmpty &&
        _itens.containsKey(marca.id)) {
      _itens.update(
          marca.id!,
          (_) =>
              Marca(id: marca.id, nome: marca.nome, imageUrl: marca.imageUrl));
    } else {
      final id = Random().nextDouble().toString();
      _itens.putIfAbsent(
        id,
        () => Marca(id: id, nome: marca.nome, imageUrl: marca.imageUrl),
      );
    }

    notifyListeners();
  }

  void remove(Marca marca) {
    if (marca != null && marca.id != null) {
      _itens.remove(marca.id);
      notifyListeners();
    }
  }
}
