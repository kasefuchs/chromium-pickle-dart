/// Aligns [number] by rounding it up to the next multiple of [alignment].
int alignInt(int number, int alignment) =>
    number + (alignment - (number % alignment)) % alignment;
