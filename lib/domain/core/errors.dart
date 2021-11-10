import 'package:flutter_notes_app/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    return Error.safeToString(
        'Encounted a ValueFailure at an unrecoverable point. Terminating. Failure was: $valueFailure');
  }
}
