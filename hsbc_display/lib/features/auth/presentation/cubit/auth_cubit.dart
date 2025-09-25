import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  String? _currentUserAuth;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(UnAuthenticated());
  }

  Future<void> login(String username, String password) async {
    try {
      emit(AuthLoading());

      final user = await authRepo.login(username, password);

      if (user != null) {
        _currentUserAuth = user.id;
        emit(Authenticated(user));
      } else {
        emit(AuthError("Invalid username or password"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  void logout() {
    try {
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  String? get currentUser => _currentUserAuth;
}
