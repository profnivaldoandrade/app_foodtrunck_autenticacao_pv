import 'package:app_foodtrunck/execoes/execoes_autenticacao.dart';
import 'package:app_foodtrunck/models/autenticacao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ModoLogin { Registrar, Login }

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _estaLogando = false;
  ModoLogin _modoLogin = ModoLogin.Login;

  final Map<String, String> _dadosLogin = {
    'email': '',
    'password': '',
  };

  void _mostrarErroDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _auternarModoLogin() {
    setState(() {
      if (_eLogin()) {
        _modoLogin = ModoLogin.Registrar;
      } else {
        _modoLogin = ModoLogin.Login;
      }
    });
  }

  Future<void> _submit() async {
    final eValido = _formKey.currentState?.validate() ?? false;

    if (!eValido) {
      return;
    }

    setState(() => _estaLogando = true);
    _formKey.currentState?.save();

    Autenticacao autenticacao = Provider.of(context, listen: false);

    try {
      if (_eLogin()) {
        await autenticacao.login(
            _dadosLogin['email']!, _dadosLogin['password']!);
      } else {
        await autenticacao.registrar(
            _dadosLogin['email']!, _dadosLogin['password']!);
      }
    } on ExecoesAutenticacao catch (error) {
      print(error);
      _mostrarErroDialog(error.toString());
    } catch (error) {
      print(error);
      _mostrarErroDialog('Ocorreu um erro inesperado');
    }
    setState(() => _estaLogando = false);
  }

  bool _eLogin() => _modoLogin == ModoLogin.Login;
  bool _eRegistro() => _modoLogin == ModoLogin.Registrar;

  @override
  Widget build(BuildContext context) {
    final tamanhoTela = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.only(top: 30),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: tamanhoTela.width * 0.75,
          height: _eLogin() ? 340 : 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'E-mail', icon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _dadosLogin['email'] = email ?? '',
                  validator: (_email) {
                    final email = _email ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informar um e-mail valido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Senha', icon: Icon(Icons.key)),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (password) =>
                      _dadosLogin['password'] = password ?? '',
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Informar senha minimo 5 caracteres';
                    }
                    return null;
                  },
                ),
                if (_eRegistro())
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Confirmar Senha', icon: Icon(Icons.key)),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (_password) {
                      final password = _password ?? '';
                      if (password != _passwordController.text) {
                        return 'Senha informadas não conferem...';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                if (_estaLogando)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      _eLogin() ? 'ENTRAR' : 'REGISTRAR',
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _auternarModoLogin,
                  child: Text(
                    _eLogin() ? 'DESEJA REGISTRAR' : 'JÁ POSSUI CONTA?',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
