/// Aligns [number] by rounding it up to the next multiple of [alignment].
int alignInt(int number, int alignment) {
  return number + (alignment - (number % alignment)) % alignment;
}
