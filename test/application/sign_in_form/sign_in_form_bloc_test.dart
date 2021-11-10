import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:flutter_notes_app/domain/auth/auth_failure.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_form_bloc_test.mocks.dart';

@GenerateMocks([IAuthFacade])
void main() {
  late MockIAuthFacade mockAuthFacade;
  late SignInFormBloc bloc;
  late SignInFormState defaultState;

  setUp(() {
    mockAuthFacade = MockIAuthFacade();
    bloc = SignInFormBloc(mockAuthFacade);
    defaultState = SignInFormState(
      emailAddress: EmailAddress(''),
      password: Password(''),
      showErrorMessages: false,
      isSubmitting: false,
      authFailureOrSuccessOption: none(),
    );
  });

  test('should have the inital state of the bloc be empty', () {
    expect(bloc.state.emailAddress, EmailAddress(''));
    expect(bloc.state.password, Password(''));
    expect(bloc.state.showErrorMessages, false);
    expect(bloc.state.isSubmitting, false);
    expect(bloc.state.authFailureOrSuccessOption, none());
  });

  group('SignInFormState.emailChanged', () {
    const String emailStr = 'matt@email.com';

    blocTest<SignInFormBloc, SignInFormState>(
      'emits an updated email address when emailChange event is added.',
      build: () => bloc,
      act: (bloc) => bloc.add(const SignInFormEvent.emailChanged(emailStr)),
      expect: () => <SignInFormState>[
        defaultState.copyWith(emailAddress: EmailAddress(emailStr)),
      ],
    );
  });

  group('SignInFormState.passwordChanged', () {
    const String passwordStr = '123456';

    blocTest<SignInFormBloc, SignInFormState>(
      'emits an updated password when passwordChange event is added.',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const SignInFormEvent.passwordChanged(passwordStr)),
      expect: () => <SignInFormState>[
        defaultState.copyWith(password: Password(passwordStr)),
      ],
    );
  });

  group('SignInFormState.registerWithEmailAndPassword', () {
    final emailAddress = EmailAddress('matt@email.com');
    final password = Password('123456');
    blocTest<SignInFormBloc, SignInFormState>(
      'should correctly call the register function in the authFacade',
      setUp: () {
        when(mockAuthFacade.registerWithEmailAndPassword(
                emailAddress: emailAddress,
                password: password))
            .thenAnswer((_) async => const Right(unit));
      },
      build: () => bloc,
      seed: () => defaultState.copyWith(
        emailAddress: emailAddress,
        password: password
      ),
      act: (bloc) =>
          bloc.add(const SignInFormEvent.registerWithEmailAndPassword()),
      expect: () => <SignInFormState>[
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: true,
        ),
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(const Right(unit)),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should show errors if the registration returns a failure',
      setUp: () {
        when(mockAuthFacade.registerWithEmailAndPassword(
                emailAddress: emailAddress,
                password: password))
            .thenAnswer((_) async => const Left(AuthFailure.emailAlreadyInUse()));
      },
      build: () => bloc,
      seed: () => defaultState.copyWith(
        emailAddress: emailAddress,
        password: password
      ),
      act: (bloc) =>
          bloc.add(const SignInFormEvent.registerWithEmailAndPassword()),
      expect: () => <SignInFormState>[
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: true,
        ),
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(const Left(AuthFailure.emailAlreadyInUse())),
        ),
      ],
    );
  });

  group('SignInFormState.signInWithEmailAndPassword', () {
    final emailAddress = EmailAddress('matt@email.com');
    final password = Password('123456');
    blocTest<SignInFormBloc, SignInFormState>(
      'should correctly call the sign in function in the authFacade',
      setUp: () {
        when(mockAuthFacade.signInWithEmailAndPassword(
                emailAddress: emailAddress,
                password: password))
            .thenAnswer((_) async => const Right(unit));
      },
      build: () => bloc,
      seed: () => defaultState.copyWith(
        emailAddress: emailAddress,
        password: password
      ),
      act: (bloc) =>
          bloc.add(const SignInFormEvent.signInWithEmailAndPassword()),
      expect: () => <SignInFormState>[
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: true,
        ),
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(const Right(unit)),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should show errors if the signInWithEmailAndPassword returns a failure',
      setUp: () {
        when(mockAuthFacade.signInWithEmailAndPassword(
                emailAddress: emailAddress,
                password: password))
            .thenAnswer((_) async => const Left(AuthFailure.invalidEmailAndPasswordCombination()));
      },
      build: () => bloc,
      seed: () => defaultState.copyWith(
        emailAddress: emailAddress,
        password: password
      ),
      act: (bloc) =>
          bloc.add(const SignInFormEvent.signInWithEmailAndPassword()),
      expect: () => <SignInFormState>[
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: true,
        ),
        defaultState.copyWith(
          emailAddress: emailAddress,
          password: password,
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: some(const Left(AuthFailure.invalidEmailAndPasswordCombination())),
        ),
      ],
    );
  });

  group('SignInFormState.signInWithGoogle', () {
    blocTest<SignInFormBloc, SignInFormState>(
      'should correctly call the signInWithGoogle function in the authFacade',
      setUp: () {
        when(mockAuthFacade.signInWithGoogle())
            .thenAnswer((_) async => const Right(unit));
      },
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const SignInFormEvent.signInWithGoogle()),
      expect: () => <SignInFormState>[
        defaultState.copyWith(
          isSubmitting: true,
        ),
        defaultState.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(const Right(unit)),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should show errors if the signInWithGoogle returns a failure',
      setUp: () {
        when(mockAuthFacade.signInWithGoogle())
            .thenAnswer((_) async => const Left(AuthFailure.cancelledByUser()));
      },
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const SignInFormEvent.signInWithGoogle()),
      expect: () => <SignInFormState>[
        defaultState.copyWith(
          isSubmitting: true,
        ),
        defaultState.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(const Left(AuthFailure.cancelledByUser())),
        ),
      ],
    );
  });
}
