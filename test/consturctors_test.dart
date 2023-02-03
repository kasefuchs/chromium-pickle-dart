import 'dart:typed_data';

import 'package:chromium_pickle/chromium_pickle.dart';
import 'package:test/test.dart';

void main() {
  group('Pickle', () {
    test('should create empty Pickle instance', () {
      Uint8List expected = Uint8List(64);
      Pickle pickle = Pickle.empty();

      expect(pickle.header, equals(expected));
      expect(pickle.headerSize, equals(4));
      expect(pickle.writeOffset, equals(0));
      expect(pickle.capacityAfterHeader, equals(64));
    });
  });
  group('Constructors.fromUint8List', () {
    test('should create readonly Pickle instance from Uint8List', () {
      Uint8List data = Uint8List.fromList([4, 0, 0, 0, 5, 172, 178, 38]);

      Pickle pickle = Pickle.fromUint8List(data);

      expect(pickle.headerSize, equals(4));
      expect(pickle.writeOffset, equals(0));
      expect(pickle.capacityAfterHeader,
          equals(PickleConstants.capacityReadOnly.value));
    });
  });
  group('PickleIterator', () {
    test('should create PickleIterator instance', () {
      Pickle pickle = Pickle.empty();
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.payload, pickle.header);
    });
  });
}
