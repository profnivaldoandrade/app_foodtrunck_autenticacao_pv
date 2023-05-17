import 'dart:convert';
import 'package:app_foodtrunck/models/item_pedido.dart';
import 'package:app_foodtrunck/models/pedido.dart';
import 'package:app_foodtrunck/models/fechar_pedido.dart';
import 'package:app_foodtrunck/utils/app_constantes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FecharPedidoItens with ChangeNotifier {
  final String _token;
  final String _userId;

  List<FecharPedido> _items = [];

  FecharPedidoItens([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<FecharPedido> get items {
    return [..._items];
  }

  int get qtdItems {
    return _items.length;
  }

  Future<void> carregarPedidosFechados() async {
    List<FecharPedido> items = [];
    final resposta = await http
        .get(Uri.parse('${AppConstantes.PEDIDO_BASE_URL}/$_userId.json?auth=$_token'));
    if (resposta.body == 'null') return;
    Map<String, dynamic> dados = jsonDecode(resposta.body);
    dados.forEach((pedidoId, predidoDados) {
      items.add(
        FecharPedido(
          id: pedidoId,
          date: DateTime.parse(predidoDados['data']),
          total: predidoDados['total'],
          produtos: (predidoDados['produtos'] as List<dynamic>).map((item) {
            return ItemPedido(
              id: item['id'],
              produtoId: item['produtoId'],
              name: item['name'],
              qtd: item['qtd'],
              preco: item['preco'],
            );
          }).toList(),
        ),
      );
    });
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addFecharPedido(Pedido pedido) async {
    final data = DateTime.now();
    final resposta = await http.post(
      Uri.parse('${AppConstantes.PEDIDO_BASE_URL}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': pedido.totalItens,
          'data': data.toIso8601String(),
          'produtos': pedido.items.values
              // ignore: non_constant_identifier_names
              .map((ItemPedido) => {
                    'id': ItemPedido.id,
                    'produtoId': ItemPedido.produtoId,
                    'name': ItemPedido.name,
                    'qtd': ItemPedido.qtd,
                    'preco': ItemPedido.preco,
                  })
              .toList(),
        },
      ),
    );
    final id = jsonDecode(resposta.body)['name'];
    _items.insert(
      0,
      FecharPedido(
        id: id,
        total: pedido.totalItens,
        produtos: pedido.items.values.toList(),
        date: data,
      ),
    );
    notifyListeners();
  }
}
