import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/autenticar_usuario.dart';
import '../../domain/usecases/obter_usuario_logado.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AutenticarUsuario autenticarUsuario,
    required ObterUsuarioLogado obterUsuarioLogado,
    required AuthRepository authRepository,
  })  : _autenticarUsuario = autenticarUsuario,
        _obterUsuarioLogado = obterUsuarioLogado,
        _authRepository = authRepository,
        super(const AuthInicial()) {
    on<LoginSolicitado>(_onLoginSolicitado);
    on<SessaoVerificada>(_onSessaoVerificada);
    on<LogoutSolicitado>(_onLogoutSolicitado);
  }

  final AutenticarUsuario _autenticarUsuario;
  final ObterUsuarioLogado _obterUsuarioLogado;
  final AuthRepository _authRepository;

  Future<void> _onLoginSolicitado(
    LoginSolicitado event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthCarregando());
    try {
      final usuario = await _autenticarUsuario(
        AutenticarUsuarioParams(email: event.email, senha: event.senha),
      );
      emit(AuthAutenticado(usuario));
    } on Failure catch (f) {
      emit(AuthErro(f.message));
    }
  }

  Future<void> _onSessaoVerificada(
    SessaoVerificada event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthCarregando());
    try {
      final usuario = await _obterUsuarioLogado();
      if (usuario != null) {
        emit(AuthAutenticado(usuario));
      } else {
        emit(const AuthNaoAutenticado());
      }
    } catch (_) {
      emit(const AuthNaoAutenticado());
    }
  }

  Future<void> _onLogoutSolicitado(
    LogoutSolicitado event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthNaoAutenticado());
  }
}
