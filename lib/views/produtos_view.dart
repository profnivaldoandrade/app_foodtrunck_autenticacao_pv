import 'package:app_foodtrunck/components/app_drower.dart';
import 'package:app_foodtrunck/components/item_produto.dart';
import 'package:app_foodtrunck/models/lista_produtos.dart';
import 'package:app_foodtrunck/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdutosView extends StatelessWidget {
  const ProdutosView({super.key});

  Future<void> _refreshProdutos(BuildContext context) {
    return Provider.of<ListaProdutos>(
      context,
      listen: false,
    ).carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    final ListaProdutos produtos = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 18),
        title: const Text('GERENCIAMENTO DE PRODUTOS'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PRODUTO_FORM),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProdutos(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: produtos.quantosItens,
            itemBuilder: (ctx, i) => Column(
              children: [
                ItemProduto(
                  produto: produtos.items[i],
                ),
                const Divider(
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
