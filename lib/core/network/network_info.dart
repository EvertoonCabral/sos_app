/// Interface para verificar conectividade de rede.
///
/// Nota: [connectivity_plus] informa o tipo de conexão (WiFi, mobile, etc.)
/// mas **não garante** acesso real à internet. Uma conexão WiFi, por exemplo,
/// pode estar sem acesso externo. Para verificar conectividade real,
/// seria necessário fazer um ping ou request de saúde ao backend.
abstract class NetworkInfo {
  /// Retorna `true` se o dispositivo possui alguma interface de rede ativa.
  Future<bool> get isConnected;

  /// Stream que emite `true`/`false` quando a conectividade muda.
  Stream<bool> get onConnectivityChanged;
}
