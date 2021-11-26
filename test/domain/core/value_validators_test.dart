import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/core/failures.dart';
import 'package:flutter_notes_app/domain/core/value_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validatePassword', () {
    test('it should fail for an empty password string', () {
      // assert
      const password = '';
      // act
      Either<ValueFailure<String>, String> result = validatePassword(password);
      // expect
      expect(result,
          left(const ValueFailure.shortPassword(failedValue: password)));
    });

    test('it should fail for a password with only 5 characters', () {
      // assert
      const password = '12345';
      // act
      Either<ValueFailure<String>, String> result = validatePassword(password);
      // expect
      expect(result,
          left(const ValueFailure.shortPassword(failedValue: password)));
    });

    test('it should pass for a password with 6 characters', () {
      // assert
      const password = '123456';
      // act
      Either<ValueFailure<String>, String> result = validatePassword(password);
      // expect
      expect(result, right(password));
    });
  });

  group('validateEmailAddress', () {
    test('it should pass with a correct email address', () {
      const emailStr = 'matt@flutter.com';
      // act
      Either<ValueFailure<String>, String> result =
          validateEmailAddress(emailStr);
      // expect
      expect(result, right(emailStr));
    });

    test('it should fail for an email without an \'@\' symbol', () {
      const emailStr = 'mattflutter.com';
      // act
      Either<ValueFailure<String>, String> result =
          validateEmailAddress(emailStr);
      // expect
      expect(
          result, left(const ValueFailure.invalidEmail(failedValue: emailStr)));
    });

    test('it should fail for an email without a \'.\'', () {
      // assert
      const emailStr = 'mattflutter';
      // act
      Either<ValueFailure<String>, String> result =
          validateEmailAddress(emailStr);
      // expect
      expect(
          result, left(const ValueFailure.invalidEmail(failedValue: emailStr)));
    });

    test('it should fail for an empty email string', () {
      // assert
      const emailStr = '';
      // act
      Either<ValueFailure<String>, String> result =
          validateEmailAddress(emailStr);
      // expect
      expect(
          result, left(const ValueFailure.invalidEmail(failedValue: emailStr)));
    });
  });

  group('validateMaxStringLength', () {
    test(
        'it should pass when a value of a greater length than the max is given',
        () {
      // assert
      const valueStr = '123456';
      const maxLength = 5;
      // act
      Either<ValueFailure<String>, String> result =
          validateMaxStringLength(valueStr, maxLength);
      // expect
      expect(result, right(valueStr));
    });

    test('it should pass when a value of the same length as the max is given',
        () {
      // assert
      const valueStr = '12345';
      const maxLength = 5;
      // act
      Either<ValueFailure<String>, String> result =
          validateMaxStringLength(valueStr, maxLength);
      // expect
      expect(result, right(valueStr));
    });

    test('it should fail when a value less than the max lenght is given', () {
      // assert
      const valueStr = '1234';
      const maxLength = 5;
      // act
      Either<ValueFailure<String>, String> result =
          validateMaxStringLength(valueStr, maxLength);
      // expect
      expect(
          result,
          left(const ValueFailure.exceedingLength(
              failedValue: valueStr, max: maxLength)));
    });
  });

  group('validateStringNotEmpty', () {
    test('it should pass with a non-empty string', () {
      // assert
      const valueStr = ' ';
      // act
      Either<ValueFailure<String>, String> result =
          validateStringNotEmpty(valueStr);
      // assert
      expect(result, right(valueStr));
    });

    test('it should fail with an empty string', () {
      // assert
      const valueStr = '';
      // act
      Either<ValueFailure<String>, String> result =
          validateStringNotEmpty(valueStr);
      // assert
      expect(result, left(const ValueFailure.empty(failedValue: valueStr)));
    });
  });

  group('validateSingleLine', () {
    test('it should pass when a single line of text is given', () {
      // assert
      const valueStr = 'test string';
      // act
      Either<ValueFailure<String>, String> result =
          validateSingleLine(valueStr);
      // assert
      expect(result, right(valueStr));
    });

    test('it should fail if a string is passed in with a new line character',
        () {
      // assert
      const valueStr = 'test string\nsecond line here';
      // act
      Either<ValueFailure<String>, String> result =
          validateSingleLine(valueStr);
      // assert
      expect(result, left(const ValueFailure.multiline(failedValue: valueStr)));
    });
  });

  group('validateMaxListLength', () {
    test(
        'it should pass when the list contains less values than the max length',
        () {
      // assert
      IList<String> list = IList.from(['1']);
      const maxLength = 2;
      // act
      Either<ValueFailure<IList<String>>, IList<String>> result =
          validateMaxListLength(list, maxLength);
      // expect
      expect(result, right(list));
    });

    test(
        'it should fail when the list contains more values than the max length',
        () {
      // assert
      IList<String> list = IList.from(['1', '2', '3']);
      const maxLength = 2;
      // act
      Either<ValueFailure<IList<String>>, IList<String>> result =
          validateMaxListLength(list, maxLength);
      // expect
      expect(result, left(ValueFailure.listTooLong(failedValue: list, max: maxLength)));
    });

    test(
        'it should pass when the list contains the same amount of values as the max length',
        () {
      // assert
      IList<String> list = IList.from(['1', '2']);
      const maxLength = 2;
      // act
      Either<ValueFailure<IList<String>>, IList<String>> result =
          validateMaxListLength(list, maxLength);
      // expect
      expect(result, right(list));
    });

    test(
        'it should also work with integers',
        () {
      // assert
      IList<int> list = IList.from([1]);
      const maxLength = 2;
      // act
      Either<ValueFailure<IList<int>>, IList<int>> result =
          validateMaxListLength(list, maxLength);
      // expect
      expect(result, right(list));
    });
  });
}
