import 'dart:io';

String fixtureReader(String name) {
  return File('test/helpers/fixtures/$name').readAsStringSync();
}
