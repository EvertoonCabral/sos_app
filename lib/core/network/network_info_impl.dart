import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'network_info.dart';

/// Implementação de [NetworkInfo] usando [connectivity_plus].
///
/// Nota: [connectivity_plus] verifica a existência de uma interface de rede
/// ativa (WiFi, celular, etc.), mas NÃO garante acesso real à internet.
/// Um dispositivo conectado a WiFi sem acesso externo será reportado como
/// "conectado". Para cenários onde isso importa, considere um health-check
/// ao backend como fallback.
@Singleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any(
      (r) => r != ConnectivityResult.none,
    );
  }
}
