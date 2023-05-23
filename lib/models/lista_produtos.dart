import 'dart:convert';
import 'dart:math';
import 'package:app_foodtrunck/execoes/http_execoes.dart';
import 'package:app_foodtrunck/models/produto.dart';
import 'package:app_foodtrunck/utils/app_constantes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaProdutos with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Produto> _items = [];

  List<Produto> get items => [..._items];
  List<Produto> get itensFavoritos =>
      _items.where((produto) => produto.eFavorito).toList();

  ListaProdutos([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get quantosItens {
    return _items.length;
  }

  Future<void> carregarProdutos() async {
    _items.clear();
    final resposta = await http
        .get(Uri.parse('${AppConstantes.PRODUTO_BASE_URL}.json?auth=$_token'));
    if (resposta.body == 'null') return;

    final favResposta = await http.get(
      Uri.parse(
          '${AppConstantes.USUARIO_FAVORITO_URL}/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> dadosFavorito =
        favResposta.body == 'null' ? {} : jsonDecode(favResposta.body);

    Map<String, dynamic> dados = jsonDecode(resposta.body);
    dados.forEach((produtoId, produtoDados) {
      final eFavorito = dadosFavorito[produtoId] ?? false;
      _items.add(
        Produto(
          id: produtoId,
          titulo: produtoDados['titulo'],
          descricao: produtoDados['descricao'],
          ingredientes: produtoDados['ingredientes'],
          preco: produtoDados['preco'],
          imgUrl: produtoDados['imgUrl'],
          eFavorito: eFavorito,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> salvarProduto(Map<String, Object> dados, List ingredientes) {
    bool temId = dados['id'] != null;
    final produto = Produto(
      id: temId ? dados['id'] as String : Random().nextDouble().toString(),
      titulo: dados['titulo'] as String,
      descricao: dados['descricao'] as String,
      ingredientes: ingredientes as List<String>,
      preco: dados['preco'] as double,
      imgUrl: dados['imgUrl'] as String,
    );
    if (temId) {
      return atualizarProduto(produto);
    } else {
      return addProduto(produto);
    }
  }

  Future<void> addProduto(Produto produto) async {
    final resposta = await http.post(
      Uri.parse('${AppConstantes.PRODUTO_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "titulo": produto.titulo,
          "descricao": produto.descricao,
          "ingredientes": produto.ingredientes,
          "preco": produto.preco,
          "imgUrl": produto.imgUrl,
        },
      ),
    );

    final id = jsonDecode(resposta.body)['name'];
    _items.add(Produto(
      id: id,
      titulo: produto.titulo,
      descricao: produto.descricao,
      ingredientes: produto.ingredientes,
      preco: produto.preco,
      imgUrl: produto.imgUrl,
    ));
    notifyListeners();
  }

  Future<void> atualizarProduto(Produto produto) async {
    int index = _items.indexWhere((p) => p.id == produto.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${AppConstantes.PRODUTO_BASE_URL}/${produto.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "titulo": produto.titulo,
            "descricao": produto.descricao,
            "ingredientes": produto.ingredientes,
            "preco": produto.preco,
            "imgUrl": produto.imgUrl,
          },
        ),
      );
      _items[index] = produto;
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> removerProduto(Produto produto) async {
    int index = _items.indexWhere((p) => p.id == produto.id);

    if (index >= 0) {
      final produto = _items[index];
      _items.remove(produto);
      notifyListeners();

      final resposta = await http.delete(
        Uri.parse(
            '${AppConstantes.PRODUTO_BASE_URL}/${produto.id}.json?auth=$_token'),
      );

      if (resposta.statusCode >= 400) {
        _items.insert(index, produto);
        notifyListeners();
        throw HttpExecoes(
          msg: 'Não Foi Possivel excluir esse produto',
          statusCode: resposta.statusCode,
        );
      }
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
