import 'package:equatable/equatable.dart';

import '../../../../core/entities/local_geo.dart';
import 'atendimento_enums.dart';

class Atendimento extends Equatable {
  const Atendimento({
    required this.id,
    required this.clienteId,
    required this.usuarioId,
    required this.pontoDeSaida,
    required this.localDeColeta,
    required this.localDeEntrega,
    required this.localDeRetorno,
    required this.distanciaEstimadaKm,
    this.distanciaRealKm,
    required this.valorPorKm,
    this.valorCobrado,
    required this.tipoValor,
    this.status = AtendimentoStatus.rascunho,
    this.observacoes,
    required this.criadoEm,
    required this.atualizadoEm,
    this.iniciadoEm,
    this.chegadaColetaEm,
    this.chegadaEntregaEm,
    this.inicioRetornoEm,
    this.concluidoEm,
    this.sincronizadoEm,
  });

  final String id;
  final String clienteId;
  final String usuarioId;

  final LocalGeo pontoDeSaida;
  final LocalGeo localDeColeta;
  final LocalGeo localDeEntrega;
  final LocalGeo localDeRetorno;

  final double distanciaEstimadaKm;
  final double? distanciaRealKm;

  final double valorPorKm;
  final double? valorCobrado;
  final TipoValor tipoValor;

  final AtendimentoStatus status;
  final String? observacoes;

  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? iniciadoEm;
  final DateTime? chegadaColetaEm;
  final DateTime? chegadaEntregaEm;
  final DateTime? inicioRetornoEm;
  final DateTime? concluidoEm;
  final DateTime? sincronizadoEm;

  Atendimento copyWith({
    String? clienteId,
    String? usuarioId,
    LocalGeo? pontoDeSaida,
    LocalGeo? localDeColeta,
    LocalGeo? localDeEntrega,
    LocalGeo? localDeRetorno,
    double? distanciaEstimadaKm,
    double? distanciaRealKm,
    double? valorPorKm,
    double? valorCobrado,
    TipoValor? tipoValor,
    AtendimentoStatus? status,
    String? observacoes,
    DateTime? atualizadoEm,
    DateTime? iniciadoEm,
    DateTime? chegadaColetaEm,
    DateTime? chegadaEntregaEm,
    DateTime? inicioRetornoEm,
    DateTime? concluidoEm,
    DateTime? sincronizadoEm,
  }) {
    return Atendimento(
      id: id,
      clienteId: clienteId ?? this.clienteId,
      usuarioId: usuarioId ?? this.usuarioId,
      pontoDeSaida: pontoDeSaida ?? this.pontoDeSaida,
      localDeColeta: localDeColeta ?? this.localDeColeta,
      localDeEntrega: localDeEntrega ?? this.localDeEntrega,
      localDeRetorno: localDeRetorno ?? this.localDeRetorno,
      distanciaEstimadaKm: distanciaEstimadaKm ?? this.distanciaEstimadaKm,
      distanciaRealKm: distanciaRealKm ?? this.distanciaRealKm,
      valorPorKm: valorPorKm ?? this.valorPorKm,
      valorCobrado: valorCobrado ?? this.valorCobrado,
      tipoValor: tipoValor ?? this.tipoValor,
      status: status ?? this.status,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      iniciadoEm: iniciadoEm ?? this.iniciadoEm,
      chegadaColetaEm: chegadaColetaEm ?? this.chegadaColetaEm,
      chegadaEntregaEm: chegadaEntregaEm ?? this.chegadaEntregaEm,
      inicioRetornoEm: inicioRetornoEm ?? this.inicioRetornoEm,
      concluidoEm: concluidoEm ?? this.concluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clienteId,
        usuarioId,
        pontoDeSaida,
        localDeColeta,
        localDeEntrega,
        localDeRetorno,
        distanciaEstimadaKm,
        distanciaRealKm,
        valorPorKm,
        valorCobrado,
        tipoValor,
        status,
        observacoes,
        criadoEm,
        atualizadoEm,
        iniciadoEm,
        chegadaColetaEm,
        chegadaEntregaEm,
        inicioRetornoEm,
        concluidoEm,
        sincronizadoEm,
      ];
}
