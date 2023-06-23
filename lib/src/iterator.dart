import 'dart:convert';
import 'dart:typed_data';

import 'enums/enums.dart';
import 'pickle.dart';
import 'utils.dart';

/// Class that used to read data from [Pickle] objects.
class PickleIterator {
  /// Index where current chunk of data starts.
  int readIndex = 0;

  /// Data stored in [Pickle] attached to this [PickleIterator].
  @Deprecated("Use Pickle.header instead")
  Uint8List get payload => pickle.header;

  /// Offset of actual [payload] data.
  @Deprecated("Use Pickle.headerSize instead")
  int get payloadOffset => pickle.headerSize;

  /// Index where current chuck of data ends.
  @Deprecated("Use Pickle.payloadSize instead")
  int get endIndex => pickle.payloadSize;


  /// [Pickle] attached to this [PickleIterator].
  Pickle pickle;

  /// Creates new [PickleIterator] instance that can be used to read data from [Pickle] objects.
  PickleIterator(this.pickle);

  /// Returns the `bytes` value of the [Pickle] object at the specified buffer [length].
  dynamic readBytes<ReturnType>(int length,
      [ReturnType Function(int)? method]) {
    int readPayloadOffset = getReadPayloadOffsetAndAdvance(length);
    if (method != null) return method(readPayloadOffset);
    return pickle.header.sublist(readPayloadOffset, readPayloadOffset + length);
  }

  /// Returns current [Pickle] object value as `int32` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readInt() {
    return readBytes<int>(
        PickleSize.int32.value,
        (readPayloadOffset) => pickle.headerView
            .getInt32(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `uint32` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readUInt32() {
    return readBytes<int>(
        PickleSize.uint32.value,
        (readPayloadOffset) => pickle.headerView
            .getUint32(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `int64` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readInt64() {
    return readBytes<int>(
        PickleSize.int64.value,
        (readPayloadOffset) => pickle.headerView
            .getInt64(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `uint64` and seeks to next data. A [RangeError] exception would be thrown when failed.
  int readUInt64() {
    return readBytes<int>(
        PickleSize.uint64.value,
        (readPayloadOffset) => pickle.headerView
            .getUint64(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `float` and seeks to next data. A [RangeError] exception would be thrown when failed.
  double readFloat() {
    return readBytes<double>(
        PickleSize.float.value,
        (readPayloadOffset) => pickle.headerView
            .getFloat32(readPayloadOffset, Endian.little));
  }

  /// Returns current [Pickle] object value as `double` and seeks to next data. A [RangeError] exception would be thrown when failed.
  double readDouble() {
    return readBytes<double>(
        PickleSize.double.value,
        (readPayloadOffset) => pickle.headerView
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
    if (length > pickle.payloadSize - readIndex) {
      readIndex = pickle.payloadSize;
      throw RangeError('Failed to read data with length of $length');
    }
    int readPayloadOffset = pickle.headerSize + readIndex;
    advance(length);
    return readPayloadOffset;
  }

  /// Seeks for next data in current [Pickle] object.
  void advance(int size) {
    int alignedSize = alignInt(size, PickleSize.uint32.value);
    if (pickle.payloadSize - readIndex < alignedSize) {
      readIndex = pickle.payloadSize;
    } else {
      readIndex += alignedSize;
    }
  }
}
