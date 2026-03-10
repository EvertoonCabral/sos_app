import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';
import 'package:sos_app/features/base/domain/repositories/base_repository.dart';
import 'package:sos_app/features/base/domain/usecases/definir_base_principal.dart';

class MockBaseRepository extends Mock implements BaseRepository {}

void main() {
  late DefinirBasePrincipal usecase;
  late MockBaseRepository mockRepository;

  setUp(() {
    mockRepository = MockBaseRepository();
    usecase = DefinirBasePrincipal(mockRepository);
  });

  final tBase = Base(
    id: 'base-001',
    nome: 'Garagem SP',
    local: const LocalGeo(
      enderecoTexto: 'Rua X, 100',
      latitude: -23.5,
      longitude: -46.6,
    ),
    isPrincipal: true,
    criadoEm: DateTime(2026, 3, 1),
  );

  test('deve definir base como principal', () async {
    when(() => mockRepository.definirPrincipal('base-001'))
        .thenAnswer((_) async => tBase);

    final result = await usecase('base-001');

    expect(result.isPrincipal, true);
    verify(() => mockRepository.definirPrincipal('base-001')).called(1);
  });

  test('deve lançar ValidationFailure quando id vazio', () async {
    expect(
      () => usecase(''),
      throwsA(isA<ValidationFailure>()),
    );
    verifyNever(() => mockRepository.definirPrincipal(any()));
  });

  test('deve lançar ValidationFailure quando id só espaços', () async {
    expect(
      () => usecase('   '),
      throwsA(isA<ValidationFailure>()),
    );
  });
}
