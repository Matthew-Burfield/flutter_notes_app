import 'package:bloc/bloc.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) {
      event.map(
        authCheckRequested: (e) async {
          final userOption = await _authFacade.getSignedInUser();
          emit(userOption.fold(
            () => const AuthState.unAuthenticated(),
            (_) => const AuthState.authenticated(),
          ));
        },
        signedOut: (e) async {
          await _authFacade.signOut();
          emit(const AuthState.unAuthenticated());
        },
      );
    });
  }
}
