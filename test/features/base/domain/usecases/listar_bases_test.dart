import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';
import 'package:sos_app/features/base/domain/repositories/base_repository.dart';
import 'package:sos_app/features/base/domain/usecases/listar_bases.dart';

class MockBaseRepository extends Mock implements BaseRepository {}

void main() {
  late ListarBases usecase;
  late MockBaseRepository mockRepository;

  setUp(() {
    mockRepository = MockBaseRepository();
    usecase = ListarBases(mockRepository);
  });

  final tBases = [
    Base(
      id: 'base-001',
      nome: 'Garagem SP',
      local: const LocalGeo(
        enderecoTexto: 'Rua X, 100',
        latitude: -23.5,
        longitude: -46.6,
      ),
      isPrincipal: true,
      criadoEm: DateTime(2026, 3, 1),
    ),
    Base(
      id: 'base-002',
      nome: 'Garagem RJ',
      local: const LocalGeo(
        enderecoTexto: 'Rua Y, 200',
        latitude: -22.9,
        longitude: -43.2,
      ),
      criadoEm: DateTime(2026, 3, 2),
    ),
  ];

  test('deve retornar lista de bases', () async {
    when(() => mockRepository.listarTodas()).thenAnswer((_) async => tBases);

    final result = await usecase();

    expect(result.length, 2);
    expect(result[0].isPrincipal, true);
    verify(() => mockRepository.listarTodas()).called(1);
  });

  test('deve retornar lista vazia', () async {
    when(() => mockRepository.listarTodas()).thenAnswer((_) async => []);

    final result = await usecase();

    expect(result, isEmpty);
  });
}
