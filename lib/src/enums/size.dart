/// Sizes of [Pickle] data types in bytes.
enum PickleSize {
  /// Int32 C type length in bytes.
  int32(4),

  /// UInt32 C type length in bytes.
  uint32(4),

  /// Int64 C type length in bytes.
  int64(8),

  /// UInt64 C type length in bytes.
  uint64(8),

  /// Float C type length in bytes.
  float(4),

  /// Double C type length in bytes.
  double(8);

  const PickleSize(this.value);

  final int value;
}
