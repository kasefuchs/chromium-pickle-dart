/// [Pickle] types size.
enum PickleSize {
  /// Int32 length.
  int32(4),

  /// UInt32 length.
  uint32(4),

  /// Int64 length.
  int64(8),

  /// uInt64 length.
  uint64(8),

  /// Float length.
  float(4),

  /// Double length.
  double(8);

  const PickleSize(this.value);

  final int value;
}
