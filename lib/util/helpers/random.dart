import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

/// Helper to work with random things
class RandomHelper {
  /// Get a random String of a specific length.
  ///
  /// If [chars] is not provided, this will use only safe chars from [_chars].
  ///
  /// Based on: https://stackoverflow.com/questions/61919395/how-to-generate-random-string-in-dart
  ///
  /// TODO: Refactor to maxLength, minLength
  static String getRandomString(int length, {String? chars = _chars}) {
    return String.fromCharCodes(Iterable.generate(length, (_) {
      return _chars.codeUnitAt(_rnd.nextInt(_chars.length));
    }));
  }
}
