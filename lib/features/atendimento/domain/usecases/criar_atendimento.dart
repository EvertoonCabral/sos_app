import 'package:equatable/equatable.dart';

import '../../../../core/entities/local_geo.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../entities/atendimento.dart';
import '../entities/atendimento_enums.dart';
import '../repositories/atendimento_repository.dart';

class CriarAtendimento {
  CriarAtendimento(this._repository, this._distanceCalculator);

  final AtendimentoRepository _repository;
  final DistanceCalculator _distanceCalculator;

  Future<Atendimento> call(CriarAtendimentoParams params) async {
    if (params.clienteId.trim().isEmpty) {
      throw const ValidationFailure(message: 'Cliente é obrigatório');
    }
    if (params.usuarioId.trim().isEmpty) {
      throw const ValidationFailure(message: 'Usuário é obrigatório');
    }

    // RN-010: calcular distância estimada com os 4 pontos
    final distanciaEstimada = _distanceCalculator.calcularEstimativa(
      saida: PontoGeo(
        latitude: params.pontoDeSaida.latitude,
        longitude: params.pontoDeSaida.longitude,
      ),
      coleta: PontoGeo(
        latitude: params.localDeColeta.latitude,
        longitude: params.localDeColeta.longitude,
      ),
      entrega: PontoGeo(
        latitude: params.localDeEntrega.latitude,
        longitude: params.localDeEntrega.longitude,
      ),
      retorno: PontoGeo(
        latitude: params.localDeRetorno.latitude,
        longitude: params.localDeRetorno.longitude,
      ),
    );

    final now = DateTime.now();
    final atendimento = Atendimento(
      id: params.id,
      clienteId: params.clienteId.trim(),
      usuarioId: params.usuarioId.trim(),
      pontoDeSaida: params.pontoDeSaida,
      localDeColeta: params.localDeColeta,
      localDeEntrega: params.localDeEntrega,
      localDeRetorno: params.localDeRetorno,
      distanciaEstimadaKm: distanciaEstimada,
      valorPorKm: params.valorPorKm,
      valorCobrado:
          params.tipoValor == TipoValor.fixo ? params.valorFixo : null,
      tipoValor: params.tipoValor,
      observacoes: params.observacoes?.trim(),
      criadoEm: now,
      atualizadoEm: now,
    );

    return _repository.criar(atendimento);
  }
}

class CriarAtendimentoParams extends Equatable {
  const CriarAtendimentoParams({
    required this.id,
    required this.clienteId,
    required this.usuarioId,
    required this.pontoDeSaida,
    required this.localDeColeta,
    required this.localDeEntrega,
    required this.localDeRetorno,
    required this.valorPorKm,
    required this.tipoValor,
    this.valorFixo,
    this.observacoes,
  });

  final String id;
  final String clienteId;
  final String usuarioId;
  final LocalGeo pontoDeSaida;
  final LocalGeo localDeColeta;
  final LocalGeo localDeEntrega;
  final LocalGeo localDeRetorno;
  final double valorPorKm;
  final TipoValor tipoValor;
  final double? valorFixo;
  final String? observacoes;

  @override
  List<Object?> get props => [
        id,
        clienteId,
        usuarioId,
        pontoDeSaida,
        localDeColeta,
        localDeEntrega,
        localDeRetorno,
        valorPorKm,
        tipoValor,
        valorFixo,
        observacoes,
      ];
}
