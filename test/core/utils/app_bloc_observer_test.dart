import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/utils/app_bloc_observer.dart';

void main() {
  group('AppBlocObserver', () {
    test('deve ser instanciável', () {
      final observer = AppBlocObserver();
      expect(observer, isNotNull);
    });
  });
}
