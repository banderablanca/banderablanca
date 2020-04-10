bool get isInDebugMode {
  // Assume we're in production mode
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code will only turn `inDebugMode` to true
  // in our development environments!
  assert(inDebugMode = true);

  return inDebugMode;
}
