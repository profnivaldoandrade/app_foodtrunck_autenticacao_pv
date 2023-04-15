import 'dart:convert';
import 'dart:math';

import 'package:app_foodtrunck/data/dados_ficticio.dart';
import 'package:app_foodtrunck/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaProdutos with ChangeNotifier {
  final _baseUrl = 'https://foodtrunck-c34b6-default-rtdb.firebaseio.com';
  final List<Produto> _items = produtosFicticio;

  List<Produto> get items => [..._items];
  List<Produto> get itensFavoritos =>
      _items.where((produto) => produto.eFavorito).toList();

  int get quantosItens {
    return _items.length;
  }

  void salvarProduto(Map<String, Object> dados, List ingredientes) {
    bool temId = dados['id'] != null;

    //final

    final produto = Produto(
      id: temId ? dados['id'] as String : Random().nextDouble().toString(),
      titulo: dados['titulo'] as String,
      descricao: dados['descricao'] as String,
      ingredientes: ingredientes as List<String>,
      preco: dados['preco'] as double,
      imgUrl: dados['imgUrl'] as String,
    );

    if (temId) {
      atualizarProduto(produto);
    } else {
      addProduto(produto);
    }
  }

  void addProduto(Produto produto) {
    final future = http.post(
      Uri.parse('$_baseUrl/produtos.json'),
      body: jsonEncode(
        {
          "titulo": produto.titulo,
          "descricao": produto.descricao,
          "ingredientes": produto.ingredientes,
          "preco": produto.preco,
          "imgUrl": produto.imgUrl,
          "eFavorito": produto.eFavorito,
        },
      ),
    );
    future.then((resposta) {
      final id = jsonDecode(resposta.body)['name'];
      _items.add(Produto(
          id: id,
          titulo: produto.titulo,
          descricao: produto.descricao,
          ingredientes: produto.ingredientes,
          preco: produto.preco,
          imgUrl: produto.imgUrl,
          eFavorito: produto.eFavorito));
    });
    notifyListeners();
  }

  void atualizarProduto(Produto produto) {
    int index = _items.indexWhere((p) => p.id == produto.id);

    if (index >= 0) {
      _items[index] = produto;
      notifyListeners();
    }
  }

  void removerProduto(Produto produto) {
    int index = _items.indexWhere((p) => p.id == produto.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == produto.id);
      notifyListeners();
    }
  }
}
// bool _mostraApenasFavoritos = false;

// List<Produto> get items {
//   if (_mostraApenasFavoritos) {
//     return _items.where((produto) => produto.eFavorito).toList();
//   }
//   return [..._items];
// }

// void mostraApenasFavoritos() {
//   _mostraApenasFavoritos = true;
//   notifyListeners();
// }

// void mostraTodos() {
//   _mostraApenasFavoritos = false;
//   notifyListeners();
// }
