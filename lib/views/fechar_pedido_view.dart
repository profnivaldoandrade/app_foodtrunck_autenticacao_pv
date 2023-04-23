import 'package:app_foodtrunck/components/app_drower.dart';
import 'package:app_foodtrunck/components/fechar_pedidos_itens.dart';
import 'package:app_foodtrunck/models/fechar_pedidos_itens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FecharPedidoView extends StatefulWidget {
  const FecharPedidoView({super.key});

  @override
  State<FecharPedidoView> createState() => _FecharPedidoViewState();
}

class _FecharPedidoViewState extends State<FecharPedidoView> {
  bool _estaCarregando = true;

  @override
  void initState() {
    super.initState();
    Provider.of<FecharPedidoItens>(context, listen: false)
        .carregarPedidosFechados()
        .then((_) {
      setState(() => _estaCarregando = false);
    });
  }

  Future<void> _refreshProdutos(BuildContext context) {
    return Provider.of<FecharPedidoItens>(
      context,
      listen: false,
    ).carregarPedidosFechados();
  }

  @override
  Widget build(BuildContext context) {
    final FecharPedidoItens pedidos = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MEUS PEDIDOS'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProdutos(context),
        child: _estaCarregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: pedidos.qtdItems,
                itemBuilder: (context, i) =>
                    FecharPedidoItensWidget(pedido: pedidos.items[i]),
              ),
      ),
    );
  }
}
