import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/core/value_objects/unique_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'should return value equality for two uniqueId objects that have the same id',
      () {
    const id = '123';
    final UniqueId id1 = UniqueId.fromUniqueString(id);
    final UniqueId id2 = UniqueId.fromUniqueString(id);
    expect(id1 == id2, true);
  });

  test('should return the expected value object string', () {
    const idStr = '123';
    final UniqueId id = UniqueId.fromUniqueString(idStr);
    expect(id.toString(), 'Value(value: Right($idStr))');
  });

  test('should return the id', () {
    const idStr = '123';
    final UniqueId id = UniqueId.fromUniqueString(idStr);
    expect(id.value, const Right(idStr));
  });
}