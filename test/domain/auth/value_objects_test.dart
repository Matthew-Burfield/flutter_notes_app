import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';
import 'package:flutter_notes_app/domain/core/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return an email address when a correct value is passed in', () {
    const emailStr = 'matt@email.com';
    final EmailAddress emailAddress = EmailAddress(emailStr);
    expect(emailAddress.value, const Right(emailStr));
  });

  test(
      'should return a ValueFailure when an incorrect email string is passed in',
      () {
    const incorrectEmailStr = 'incorrect_email_string';
    final EmailAddress emailAddress = EmailAddress(incorrectEmailStr);
    expect(emailAddress.value,
        const Left(ValueFailure.invalidEmail(failedValue: incorrectEmailStr)));
  });

  test('should return password when a correct value is passed in', () {
    const passwordStr = 'password123';
    final Password password = Password(passwordStr);
    expect(password.value, const Right(passwordStr));
  });

  test(
      'should return a ValueFailure when an incorrect password string is passed in',
      () {
    const incorrectPasswordStr = '123';
    final Password password = Password(incorrectPasswordStr);
    expect(password.value,
        const Left(ValueFailure.shortPassword(failedValue: incorrectPasswordStr)));
  });
}
