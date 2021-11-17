import 'package:flutter_notes_app/domain/core/value_objects/unique_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required UniqueId id,
  }) = _User;
}
