import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthState {
  final String email;
  final String haslo;

  AuthState({this.email = '', this.haslo = ''});

  AuthState copyWith({String? email, String? haslo}) {
    return AuthState(
      email: email ?? this.email,
      haslo: haslo ?? this.haslo,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setHaslo(String haslo) {
    state = state.copyWith(haslo: haslo);
  }

  void reset() {
    state = AuthState();
  }
}
