import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes_app/domain/auth/auth_failure.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';
import 'package:flutter_notes_app/domain/core/errors.dart';
import 'package:flutter_notes_app/infrastructure/auth/firebase_auth_facade.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_auth_facade_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  UserCredential,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  GoogleAuthProvider,
  OAuthCredential
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUserCredential mockUserCredential;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late FirebaseAuthFacade firebaseAuthFacade;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    firebaseAuthFacade = FirebaseAuthFacade(mockFirebaseAuth, mockGoogleSignIn);
  });

  group('registerWithEmailAndPassword', () {
    const emailAddressStr = 'matt@email.com';
    const passwordStr = '123456';
    final emailAddress = EmailAddress(emailAddressStr);
    final password = Password(passwordStr);
    test(
        'should call "createUserWithEmailAndPassword" when vaild email address and password is provided',
        () async {
      // assert
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      // act
      final result = await firebaseAuthFacade.registerWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      ));
      verifyNoMoreInteractions(mockFirebaseAuth);
      expect(result, const Right(unit));
    });

    test('should throw an exception if the email address is invalid', () async {
      const invalidEmailAddressStr = 'matt';
      final invaildEmailAddress = EmailAddress(invalidEmailAddressStr);

      expect(
          () async => await firebaseAuthFacade.registerWithEmailAndPassword(
                emailAddress: invaildEmailAddress,
                password: password,
              ),
          throwsA(isA<UnexpectedValueError>()));
    });

    test('should throw an exception if the password is invalid', () async {
      const invalidPasswordStr = '1';
      final invalidPassword = Password(invalidPasswordStr);

      expect(
          () async => await firebaseAuthFacade.registerWithEmailAndPassword(
                emailAddress: emailAddress,
                password: invalidPassword,
              ),
          throwsA(isA<UnexpectedValueError>()));
    });

    test(
        'should return an AuthFailure.emailAlreadyInUse if firebase returns an exception',
        () async {
      //assert
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      //act
      final result = await firebaseAuthFacade.registerWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      expect(result, equals(const Left(AuthFailure.emailAlreadyInUse())));
    });

    test(
        'should return an AuthFailure.serverError if firebase returns any other exception',
        () async {
      //assert
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: ''));

      //act
      final result = await firebaseAuthFacade.registerWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      expect(result, equals(const Left(AuthFailure.serverError())));
    });
  });

  group('signInWithEmailAddress', () {
    const emailAddressStr = 'matt@email.com';
    const passwordStr = '123456';
    final emailAddress = EmailAddress(emailAddressStr);
    final password = Password(passwordStr);
    test(
        'should call firebase "signInWithEmailAndPassword" when vaild email address and password is provided',
        () async {
      // assert
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      // act
      final result = await firebaseAuthFacade.signInWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      ));
      verifyNoMoreInteractions(mockFirebaseAuth);
      expect(result, const Right(unit));
    });

    test('should throw an exception if the email address is invalid', () async {
      const invalidEmailAddressStr = 'matt';
      final invaildEmailAddress = EmailAddress(invalidEmailAddressStr);

      expect(
          () async => await firebaseAuthFacade.signInWithEmailAndPassword(
                emailAddress: invaildEmailAddress,
                password: password,
              ),
          throwsA(isA<UnexpectedValueError>()));
    });

    test('should throw an exception if the password is invalid', () async {
      const invalidPasswordStr = '1';
      final invalidPassword = Password(invalidPasswordStr);

      expect(
          () async => await firebaseAuthFacade.signInWithEmailAndPassword(
                emailAddress: emailAddress,
                password: invalidPassword,
              ),
          throwsA(isA<UnexpectedValueError>()));
    });

    test(
        'should return an AuthFailure.invalidEmailAndPasswordCombination if firebase returns a wrong-password exception',
        () async {
      //assert
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      //act
      final result = await firebaseAuthFacade.signInWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      expect(result,
          equals(const Left(AuthFailure.invalidEmailAndPasswordCombination())));
    });

    test(
        'should return an AuthFailure.invalidEmailAndPasswordCombination if firebase returns a user-not-found exception',
        () async {
      //assert
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      //act
      final result = await firebaseAuthFacade.signInWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      expect(result,
          equals(const Left(AuthFailure.invalidEmailAndPasswordCombination())));
    });

    test(
        'should return an AuthFailure.serverError if firebase returns any other exception',
        () async {
      //assert
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: ''));

      //act
      final result = await firebaseAuthFacade.signInWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      //expect
      expect(result, equals(const Left(AuthFailure.serverError())));
    });
  });

  group('signInWithGoogle', () {
    test(
        'should return "cancelledByUser" failure if the sign in flow if the signIn method returns null',
        () async {
      // assert
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      // act
      final result = await firebaseAuthFacade.signInWithGoogle();

      // expect
      verify(mockGoogleSignIn.signIn());
      expect(result, equals(const Left(AuthFailure.cancelledByUser())));
    });

    test('should sign in with google credentials if everything is successful',
        () async {
      // assert
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('access_token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id_token');

      // act
      final result = await firebaseAuthFacade.signInWithGoogle();

      //expect
      verify(mockGoogleSignIn.signIn());
      // verify(mockFirebaseAuth.signInWithCredential).called(1);
      // verifyNoMoreInteractions(mockFirebaseAuth);
      expect(result, const Right(unit));
    });

    test(
        'should return an AuthFailure.serverError if the signInWithCredential throws an error',
        () async {
      // assert
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenThrow(FirebaseAuthException(code: ''));
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('access_token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id_token');

      // act
      final result = await firebaseAuthFacade.signInWithGoogle();

      //expect
      verify(mockGoogleSignIn.signIn());
      // verify(mockFirebaseAuth.signInWithCredential).called(1);
      // verifyNoMoreInteractions(mockFirebaseAuth);
      expect(result, const Left(AuthFailure.serverError()));
    });
  });
}
