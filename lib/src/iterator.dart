import 'dart:convert';
import 'dart:typed_data';

import 'enums/enums.dart';
import 'pickle.dart';
import 'utils.dart';

class PickleIterator {
  late Uint8List payload;
  late int payloadOffset;
  late int readIndex;
  late int endIndex;

  /// Creates new [PickleIterator] instance that can be used to read data from [Pickle] objects.
  PickleIterator(Pickle pickle) {
    payload = pickle.header;
    payloadOffset = pickle.headerSize;
    readIndex = 0;
    endIndex = pickle.getPayloadSize();
  }

  /// Returns the `bytes` value of the [Pickle] object at the specified buffer [length].
  dynamic readBytes<ReturnType>(int length,
      [ReturnType Function(int)? method]) {
    int readPayloadOffset = getReadPayloadOffsetAndAdvance(length);
    if (method != null) return method(readPayloadOffset);
    return payload.sublist(readPayloadOffset, readPayloadOffset + length);
  }

  /// Returns current [Pickle] object value as `int32` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readInt() {
    return readBytes<int>(
        PickleSize.int32.value,
        (readPayloadOffset) => ByteData.view(payload.buffer)
            .getInt32(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `uint32` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readUInt32() {
    return readBytes<int>(
        PickleSize.uint32.value,
        (readPayloadOffset) => ByteData.view(payload.buffer)
            .getUint32(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `int64` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readInt64() {
    return readBytes<int>(
        PickleSize.int64.value,
        (readPayloadOffset) => ByteData.view(payload.buffer)
            .getInt64(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `uint64` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readUInt64() {
    return readBytes<int>(
        PickleSize.uint64.value,
        (readPayloadOffset) => ByteData.view(payload.buffer)
            .getUint64(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `float` and seeks to next data. A [RangeError] exception would be thrown when failed.
  double readFloat() {
    return readBytes<double>(
        PickleSize.float.value,
        (readPayloadOffset) => ByteData.view(payload.buffer)
            .getFloat32(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `double` and seeks to next data. A [RangeError] exception would be thrown when failed.
  double readDouble() {
    return readBytes<double>(
        PickleSize.double.value,
        (readPayloadOffset) => ByteData.view(payload.buffer)
            .getFloat64(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `bool` and seeks to next data. A [RangeError] exception would be thrown when failed.
  bool readBool() {
    return readInt() != 0;
  }

  /// Returns current [Pickle] object value as `string` and seeks to next data. A [RangeError] exception would be thrown when failed.
  String readString() {
    return utf8.decode(readBytes(readInt()));
  }

  /// Gets read payload offset and seeks for next data in current [Pickle] object.
  int getReadPayloadOffsetAndAdvance(int length) {
    if (length > endIndex - readIndex) {
      readIndex = endIndex;
      throw RangeError('Failed to read data with length of $length');
    }
    int readPayloadOffset = payloadOffset + readIndex;
    advance(length);
    return readPayloadOffset;
  }

  /// Seeks for next data in current [Pickle] object.
  void advance(int size) {
    int alignedSize = alignInt(size, PickleSize.uint32.value);
    if (endIndex - readIndex < alignedSize) {
      readIndex = endIndex;
    } else {
      readIndex += alignedSize;
    }
  }
}
