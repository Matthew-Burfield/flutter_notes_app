import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes_app/domain/core/failures.dart';
import 'package:flutter_notes_app/domain/core/value_object.dart';
import 'package:flutter_notes_app/domain/core/value_transformers.dart';
import 'package:flutter_notes_app/domain/core/value_validators.dart';

class NoteBody extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength = 1000;

  factory NoteBody(String input) {
    return NoteBody._(validateMaxStringLength(input, maxLength)
        .flatMap(validateStringNotEmpty));
  }

  const NoteBody._(this.value);
}

class TodoName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static int maxLength = 30;

  factory TodoName(String input) {
    return TodoName._(validateMaxStringLength(input, maxLength)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine));
  }

  const TodoName._(this.value);
}

class NoteColor extends ValueObject<Color> {
  @override
  final Either<ValueFailure<Color>, Color> value;

  static const List<Color> predefinedColor = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  factory NoteColor(Color input) {
    return NoteColor._(
      right(makeColorOpaque(input)),
    );
  }

  const NoteColor._(this.value);
}

class TodoList<T> extends ValueObject<IList<T>> {
  @override
  final Either<ValueFailure<IList<T>>, IList<T>> value;

  static int maxLength = 3;

  factory TodoList(IList<T> input) {
    return TodoList._(validateMaxListLength(input, maxLength));
  }

  const TodoList._(this.value);

  int get length {
    return value.getOrElse(() {
      IList<T> emptyList = IList.from([]);
      return emptyList;
    }).length();
  }

  bool get isFull {
    return length == maxLength;
  }
}
