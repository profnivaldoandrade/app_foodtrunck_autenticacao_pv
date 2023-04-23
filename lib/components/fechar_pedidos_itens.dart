import 'package:app_foodtrunck/models/fechar_pedido.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FecharPedidoItensWidget extends StatefulWidget {
  final FecharPedido pedido;

  const FecharPedidoItensWidget({
    required this.pedido,
    super.key,
  });

  @override
  State<FecharPedidoItensWidget> createState() =>
      _FecharPedidoItensWidgetState();
}

class _FecharPedidoItensWidgetState extends State<FecharPedidoItensWidget> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'R\$ ${widget.pedido.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.pedido.date),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expandido = !_expandido;
                });
              },
              icon: const Icon(Icons.expand_more),
            ),
          ),
          if (_expandido)
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                height: (widget.pedido.produtos.length * 25.0) + 10,
                child: ListView(
                  children: widget.pedido.produtos.map((produto) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            produto.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            '${produto.qtd}x R\$ ${produto.preco}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ]);
                  }).toList(),
                ))
        ],
      ),
    );
  }
}
