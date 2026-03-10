import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';
import 'package:sos_app/features/base/domain/repositories/base_repository.dart';
import 'package:sos_app/features/base/domain/usecases/criar_base.dart';

class MockBaseRepository extends Mock implements BaseRepository {}

void main() {
  late CriarBase usecase;
  late MockBaseRepository mockRepository;

  setUp(() {
    mockRepository = MockBaseRepository();
    usecase = CriarBase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      Base(
        id: 'fb',
        nome: 'fb',
        local: const LocalGeo(enderecoTexto: 'fb', latitude: 0, longitude: 0),
        criadoEm: DateTime(2026),
      ),
    );
  });

  final tBase = Base(
    id: 'base-001',
    nome: 'Garagem SP',
    local: const LocalGeo(
      enderecoTexto: 'Rua das Garagens, 100',
      latitude: -23.5,
      longitude: -46.6,
    ),
    criadoEm: DateTime(2026, 3, 1),
  );

  test('deve criar base quando nome válido', () async {
    when(() => mockRepository.criar(any())).thenAnswer((_) async => tBase);

    final result = await usecase(tBase);

    expect(result, tBase);
    verify(() => mockRepository.criar(tBase)).called(1);
  });

  test('deve lançar ValidationFailure quando nome vazio', () async {
    final baseInvalida = Base(
      id: 'base-002',
      nome: '',
      local: const LocalGeo(
        enderecoTexto: 'X',
        latitude: 0,
        longitude: 0,
      ),
      criadoEm: DateTime(2026),
    );

    expect(
      () => usecase(baseInvalida),
      throwsA(isA<ValidationFailure>()),
    );
    verifyNever(() => mockRepository.criar(any()));
  });

  test('deve lançar ValidationFailure quando nome só espaços', () async {
    final baseInvalida = Base(
      id: 'base-003',
      nome: '   ',
      local: const LocalGeo(
        enderecoTexto: 'X',
        latitude: 0,
        longitude: 0,
      ),
      criadoEm: DateTime(2026),
    );

    expect(
      () => usecase(baseInvalida),
      throwsA(isA<ValidationFailure>()),
    );
  });
}
