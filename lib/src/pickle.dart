import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'enums/enums.dart';
import 'iterator.dart';
import 'utils.dart';

/// Class that provides facilities for basic packing and unpacking of binary values.
class Pickle {
  late Uint8List header;
  late int headerSize;
  late int capacityAfterHeader;
  late int writeOffset;

  /// Returns an empty [Pickle] object.
  Pickle.empty() {
    header = Uint8List(0);
    headerSize = PickleSize.uint32.value;
    capacityAfterHeader = 0;
    writeOffset = 0;

    resize(PickleConstants.payloadUnit.value);
    setPayloadSize(0);
  }

  /// Returns a [Pickle] object that initialized from a [Uint8List].
  Pickle.fromUint8List(Uint8List buffer) {
    header = buffer;
    headerSize = buffer.length - getPayloadSize();
    capacityAfterHeader = PickleConstants.capacityReadOnly.value;
    writeOffset = 0;

    if (headerSize > buffer.length ||
        headerSize != alignInt(headerSize, PickleSize.uint32.value)) {
      headerSize = 0;
    }

    if (headerSize == 0) header = Uint8List(0);
  }

  /// Returns a [PickleIterator] that can be used to read data from this [Pickle] object.
  PickleIterator createIterator() {
    return PickleIterator(this);
  }

  /// Returns a [Uint8List] that contains this [Pickle] object data.
  Uint8List toUint8List() {
    return header.sublist(0, headerSize + getPayloadSize());
  }

  /// Returns a [int] that contains this [Pickle] object payload size.
  int getPayloadSize() {
    return ByteData.view(header.buffer).getUint32(0, Endian.little);
  }

  /// Sets this [Pickle] object payload size.
  void setPayloadSize(int size) {
    ByteData.view(header.buffer).setUint32(0, size, Endian.little);
  }

  /// Writes `bytes` to [Pickle] object. Returns `true` when succeeded and returns `false` when failed.
  bool writeBytes(dynamic data, int length, [Function(int)? method]) {
    int dataLength = alignInt(length, PickleSize.uint32.value);
    int newSize = this.writeOffset + dataLength;
    int endOffset = headerSize + this.writeOffset + length;
    int writeOffset = headerSize + this.writeOffset;

    if (newSize > capacityAfterHeader) {
      resize(max(capacityAfterHeader * 2, newSize));
    }

    if (method != null) {
      method(writeOffset);
    } else {
      header.setRange(writeOffset, endOffset, data);
    }

    header.fillRange(endOffset, endOffset + dataLength - length, 0);

    setPayloadSize(newSize);
    this.writeOffset = newSize;

    return true;
  }

  /// Writes [value] to [Pickle] object as `bool`. Returns `true` when succeeded and returns `false` when failed.
  bool writeBool(bool value) {
    return writeInt(value ? 1 : 0);
  }

  /// Writes [value] to [Pickle] object as `string`. Returns `true` when succeeded and returns `false` when failed.
  bool writeString(String value) {
    List<int> bytes = utf8.encode(value);
    int length = bytes.length;

    if (!writeInt(length)) return false;

    return writeBytes(bytes, length);
  }

  /// Writes [value] to [Pickle] object as `int32`. Returns `true` when succeeded and returns `false` when failed.
  bool writeInt(int value) {
    return writeBytes(
        value,
        PickleSize.int32.value,
        (writeHeaderOffset) => ByteData.view(header.buffer)
            .setInt32(writeHeaderOffset, value, Endian.little));
  }

  /// Writes [value] to [Pickle] object as `uint32`. Returns `true` when succeeded and returns `false` when failed.
  bool writeUInt32(int value) {
    return writeBytes(
        value,
        PickleSize.uint32.value,
        (writeHeaderOffset) => ByteData.view(header.buffer)
            .setUint32(writeHeaderOffset, value, Endian.little));
  }

  /// Writes [value] to [Pickle] object as `int64`. Returns `true` when succeeded and returns `false` when failed.
  bool writeInt64(int value) {
    return writeBytes(
        value,
        PickleSize.int64.value,
        (writeHeaderOffset) => ByteData.view(header.buffer)
            .setInt64(writeHeaderOffset, value, Endian.little));
  }

  /// Writes [value] to [Pickle] object as `uint64`. Returns `true` when succeeded and returns `false` when failed.
  bool writeUInt64(int value) {
    return writeBytes(
        value,
        PickleSize.uint64.value,
        (writeHeaderOffset) => ByteData.view(header.buffer)
            .setUint64(writeHeaderOffset, value, Endian.little));
  }

  /// Writes [value] to [Pickle] object as `float`. Returns `true` when succeeded and returns `false` when failed.
  bool writeFloat(double value) {
    return writeBytes(
        value,
        PickleSize.float.value,
        (writeHeaderOffset) => ByteData.view(header.buffer)
            .setFloat32(writeHeaderOffset, value, Endian.little));
  }

  /// Writes [value] to [Pickle] object as `double`. Returns `true` when succeeded and returns `false` when failed.
  bool writeDouble(double value) {
    return writeBytes(
        value,
        PickleSize.double.value,
        (writeHeaderOffset) => ByteData.view(header.buffer)
            .setFloat64(writeHeaderOffset, value, Endian.little));
  }

  /// Resizes this [Pickle] object header capacity.
  void resize(int capacity) {
    int newCapacity = alignInt(capacity, PickleConstants.payloadUnit.value);
    Uint8List newHeader = Uint8List(newCapacity);

    BytesBuilder builder = BytesBuilder()
      ..add(header)
      ..add(newHeader);

    header = builder.toBytes();
    capacityAfterHeader = newCapacity;
  }
}
