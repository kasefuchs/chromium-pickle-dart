import 'dart:math';
import 'dart:typed_data';

import 'package:chromium_pickle/chromium_pickle.dart';
import 'package:test/test.dart';

void main() {
  group('Read & Write', () {
    test('should write int32 to Pickle', () {
      int expected = Random().nextInt(0x7fffffff);

      Pickle pickle = Pickle.empty()..writeInt(expected);
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.readInt(), expected);
    });

    test('should write float to Pickle', () {
      double expected = Random().nextDouble();

      Pickle pickle = Pickle.empty()..writeFloat(expected);
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.readFloat(), closeTo(expected, 0.0001));
    });

    test('should write bool to Pickle', () {
      bool expected = Random().nextBool();

      Pickle pickle = Pickle.empty()..writeBool(expected);
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.readBool(), expected);
    });

    test('should write simple string to Pickle', () {
      List<String> letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")..shuffle();
      String expected = letters.join("");

      Pickle pickle = Pickle.empty()..writeString(expected);
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.readString(), expected);
    });

    test('should write multi-byte string to Pickle', () {
      List<String> letters = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ".split("")..shuffle();
      String expected = letters.join("");

      Pickle pickle = Pickle.empty()..writeString(expected);
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.readString(), expected);
    });

    test('should write buffer to Pickle', () {
      Random random = Random();
      int size = 32;

      Uint8List expected = Uint8List.fromList(
        List.generate(size, (index) => random.nextInt(256)),
      );

      Pickle pickle = Pickle.empty()..writeBytes(expected, size);
      PickleIterator iterator = pickle.createIterator();

      expect(iterator.readBytes(size), expected);
    });
  });
}
