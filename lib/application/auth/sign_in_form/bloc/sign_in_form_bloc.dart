import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/auth/auth_failure.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_event.part.dart';
part 'sign_in_form_state.part.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade)
      : super(_SignInFormState(
          emailAddress: EmailAddress(''),
          password: Password(''),
          showErrorMessages: false,
          isSubmitting: false,
          authFailureOrSuccessOption: none(),
        )) {
    on<SignInFormEvent>((eventList, emit) async {
      await eventList.map(
        emailChanged: (event) {
          emit(state.copyWith(
            emailAddress: EmailAddress(event.emailStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        passwordChanged: (event) {
          emit(state.copyWith(
            password: Password(event.passwordStr),
            authFailureOrSuccessOption: none(),
          ));
        },
        registerWithEmailAndPassword: (event) async {
          await _performActionOnAuthFacadeWithEmailAndPassword(
            emit,
            _authFacade.registerWithEmailAndPassword,
          );
        },
        signInWithEmailAndPassword: (event) async {
          await _performActionOnAuthFacadeWithEmailAndPassword(
            emit,
            _authFacade.signInWithEmailAndPassword,
          );
        },
        signInWithGoogle: (event) async {
          emit(state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: none(),
          ));
          final failureOrSuccess = await _authFacade.signInWithGoogle();
          emit(
            state.copyWith(
              isSubmitting: false,
              authFailureOrSuccessOption: some(failureOrSuccess),
            ),
          );
        },
      );
    });
  }

  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Emitter<SignInFormState> emit,
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
      emit(state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        // optionOf is equivalent to:
        // failureOrSuccess == null ? none() : some(failureOrSuccess)
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ));
    }
  }

  // Future<void> _completeFormAction(Emitter<SignInFormState> emit,
  //     Either<AuthFailure, Unit>? failureOrSuccess) {
  //   return emit(state.copyWith(
  //     isSubmitting: false,
  //     showErrorMessages: true,
  //     // optionOf is equivalent to:
  //     // failureOrSuccess == null ? none() : some(failureOrSuccess)
  //     authFailureOrSuccessOption: optionOf(failureOrSuccess),
  //   ));
  // }
}
