import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_notes_app/domain/auth/user.dart';
import 'package:flutter_notes_app/domain/core/value_objects/unique_id.dart';

extension FirebaseUserDomainX on firebase.User {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}
