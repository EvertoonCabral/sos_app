import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../domain/usecases/calcular_valor_real.dart';
import '../../domain/usecases/obter_percurso.dart';
import '../../domain/usecases/registrar_ponto.dart';
import 'rastreamento_event.dart';
import 'rastreamento_state.dart';

class RastreamentoBloc extends Bloc<RastreamentoEvent, RastreamentoState> {
  RastreamentoBloc({
    required RegistrarPonto registrarPonto,
    required ObterPercurso obterPercurso,
    required CalcularValorReal calcularValorReal,
    required DistanceCalculator distanceCalculator,
  })  : _registrarPonto = registrarPonto,
        _obterPercurso = obterPercurso,
        _calcularValorReal = calcularValorReal,
        _distanceCalculator = distanceCalculator,
        super(const RastreamentoInicial()) {
    on<IniciarRastreamentoEvent>(_onIniciar);
    on<PararRastreamentoEvent>(_onParar);
    on<RegistrarPontoEvent>(_onRegistrarPonto);
    on<ObterPercursoEvent>(_onObterPercurso);
    on<CalcularValorRealEvent>(_onCalcularValorReal);
  }

  final RegistrarPonto _registrarPonto;
  final ObterPercurso _obterPercurso;
  final CalcularValorReal _calcularValorReal;
  final DistanceCalculator _distanceCalculator;

  String? _atendimentoIdAtivo;
  int _pontosColetados = 0;

  String? get atendimentoIdAtivo => _atendimentoIdAtivo;

  Future<void> _onIniciar(
    IniciarRastreamentoEvent event,
    Emitter<RastreamentoState> emit,
  ) async {
    _atendimentoIdAtivo = event.atendimentoId;
    _pontosColetados = 0;
    emit(RastreamentoEmAndamento(
      atendimentoId: event.atendimentoId,
      pontosColetados: _pontosColetados,
    ));
  }

  Future<void> _onParar(
    PararRastreamentoEvent event,
    Emitter<RastreamentoState> emit,
  ) async {
    _atendimentoIdAtivo = null;
    _pontosColetados = 0;
    emit(const RastreamentoParado());
  }

  Future<void> _onRegistrarPonto(
    RegistrarPontoEvent event,
    Emitter<RastreamentoState> emit,
  ) async {
    if (_atendimentoIdAtivo == null) return;
    try {
      await _registrarPonto(event.ponto);
      _pontosColetados++;
      emit(RastreamentoEmAndamento(
        atendimentoId: _atendimentoIdAtivo!,
        pontosColetados: _pontosColetados,
      ));
    } on Failure catch (f) {
      emit(RastreamentoErro(f.message));
    }
  }

  Future<void> _onObterPercurso(
    ObterPercursoEvent event,
    Emitter<RastreamentoState> emit,
  ) async {
    try {
      final pontos = await _obterPercurso(event.atendimentoId);
      emit(PercursoCarregado(pontos));
    } on Failure catch (f) {
      emit(RastreamentoErro(f.message));
    }
  }

  Future<void> _onCalcularValorReal(
    CalcularValorRealEvent event,
    Emitter<RastreamentoState> emit,
  ) async {
    try {
      final pontos = await _obterPercurso(event.atendimentoId);
      final pontosGeo = pontos
          .map((p) => PontoGeo(latitude: p.latitude, longitude: p.longitude))
          .toList();
      final distanciaKm = _distanceCalculator.calcularTotal(pontosGeo);
      final valorReal = await _calcularValorReal(
        atendimentoId: event.atendimentoId,
        valorPorKm: event.valorPorKm,
      );
      emit(ValorRealCalculado(valorReal: valorReal, distanciaKm: distanciaKm));
    } on Failure catch (f) {
      emit(RastreamentoErro(f.message));
    }
  }
}
