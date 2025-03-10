import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/authProvider.dart';

class UserGetter {
  UserGetter(this.ref);
  final WidgetRef ref;
  Future<String> getUser() async {
    final authState = ref.read(authProvider);
    UserCredential credentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: authState.email, password: authState.haslo);

    return credentials.user!.uid;
  }
}
