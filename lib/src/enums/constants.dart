/// [Pickle] constants.
enum PickleConstants {
  /// Largest JS number.
  capacityReadOnly(9007199254740992),

  /// The allocation granularity of the payload.
  payloadUnit(64);

  const PickleConstants(this.value);

  final int value;
}
