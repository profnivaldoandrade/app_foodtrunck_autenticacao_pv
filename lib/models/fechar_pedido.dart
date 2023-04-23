import 'package:app_foodtrunck/models/item_pedido.dart';

class FecharPedido {
  final String id;
  final double total;
  final List<ItemPedido> produtos;
  final DateTime date;

  FecharPedido(
      {required this.id,
      required this.total,
      required this.produtos,
      required this.date});
}
