class ExecoesAutenticacao implements Exception{
  static const Map<String, String> erros = {
    'EMAIL_EXISTS':'E-mail já Cadastrado',
    'OPERATION_NOT_ALLOWED':'Operação não Permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':'Acesso Bloqueado Temporariamente. Tente mais tarde',
    'EMAIL_NOT_FOUND':'E-mail não encontrado',
    'INVALID_PASSWORD:':'Senha informada não confere',
    'USER_DISABLED:':'A conta do usuario foi desabilitada',
  };
  
  final String key;

  ExecoesAutenticacao(this.key);

  @override
  String toString(){
    return erros[key]?? 'Ocorreu um erro no processo de autenticação';
  }

}