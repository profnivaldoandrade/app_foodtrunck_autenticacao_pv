import 'package:app_foodtrunck/models/lista_produtos.dart';
import 'package:app_foodtrunck/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormProdutoView extends StatefulWidget {
  const FormProdutoView({super.key});

  @override
  State<FormProdutoView> createState() => _FormProdutoViewState();
}

class _FormProdutoViewState extends State<FormProdutoView> {
  final _precoFocus = FocusNode();
  final _descricaoFocus = FocusNode();
  final _imgUrlFocuus = FocusNode();
  final _imgUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  List<TextEditingController> listController = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    _imgUrlFocuus.addListener(atualizaImagem);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final produto = arg as Produto;
        _formData['id'] = produto.id;
        _formData['titulo'] = produto.titulo;
        _formData['preco'] = produto.preco;
        _formData['descricao'] = produto.descricao;
        _formData['imgUrl'] = produto.imgUrl;

        _imgUrlController.text = produto.imgUrl;

        for (var i = 0; i < produto.ingredientes.length; i++) {
          listController[i].text = produto.ingredientes[i];
          if (i < produto.ingredientes.length - 1) {
            listController.add(TextEditingController());
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _precoFocus.dispose();
    _descricaoFocus.dispose();
    _imgUrlFocuus.removeListener(atualizaImagem);
    _imgUrlFocuus.dispose();
  }

  void atualizaImagem() {
    setState(() {});
  }

  bool eImgUrlValida(String url) {
    bool eUrlValida = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool eExtValida = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return eUrlValida && eExtValida;
  }

  void _submitForm() {
    final eValido = _formKey.currentState?.validate() ?? false;

    if (!eValido) {
      return;
    }

    List<String> ingredientes = [];
    for (var i = 0; i < listController.length; i++) {
      ingredientes.add(listController[i].text);
    }
    _formKey.currentState?.save();

    Provider.of<ListaProdutos>(context, listen: false)
        .salvarProduto(_formData, ingredientes);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 18),
        title: const Text('FORMULÁRIO DE PRODUTO'),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['titulo']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  errorStyle: TextStyle(fontSize: 15),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_precoFocus),
                onSaved: (titulo) => _formData['titulo'] = titulo ?? '',
                validator: (titulo) {
                  if (titulo!.trim().isEmpty) {
                    return 'Título é Obrigatorio';
                  }
                  if (titulo.trim().length < 3) {
                    return 'Digite no Min 3 Caracteres';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['preco']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  errorStyle: TextStyle(fontSize: 15),
                ),
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                focusNode: _precoFocus,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descricaoFocus),
                onSaved: (preco) =>
                    _formData['preco'] = double.parse(preco ?? '0'),
                validator: (preco) {
                  final precoValido = double.tryParse(preco!) ?? -1;
                  if (precoValido <= 0) {
                    return 'Informe um preço válido';
                  }
                },
              ),
              TextFormField(
                initialValue: _formData['descricao']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                textInputAction: TextInputAction.next,
                focusNode: _descricaoFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descricaoFocus),
                onSaved: (descricao) =>
                    _formData['descricao'] = descricao ?? '',
                validator: (descricao) {
                  if (descricao!.trim().isEmpty) {
                    return 'Descrição é Obrigatoria';
                  }
                  if (descricao.trim().length < 10) {
                    return 'Digite no Min 10 Caracteres';
                  }

                  return null;
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listController.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: listController[index],
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Ingredientes',
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      listController
                                          .add(TextEditingController());
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        index != 0
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    listController[index].clear();
                                    listController[index].dispose();
                                    listController.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Url da Imagem',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        errorStyle: TextStyle(fontSize: 15),
                      ),
                      textInputAction: TextInputAction.done,
                      focusNode: _imgUrlFocuus,
                      keyboardType: TextInputType.url,
                      controller: _imgUrlController,
                      onSaved: (imgUrl) => _formData['imgUrl'] = imgUrl ?? '',
                      onFieldSubmitted: (_) => _submitForm(),
                      validator: (imgUrl) {
                        if (!eImgUrlValida(imgUrl!)) {
                          return 'Informe uma Url vãlida';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                    alignment: Alignment.center,
                    child: _imgUrlController.text.isEmpty
                        ? Text(
                            'informe a Url',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imgUrlController.text),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
