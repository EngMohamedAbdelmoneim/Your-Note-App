import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({
    required this.userRepository
  }) : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      add(AuthenticationUserChangedEvent(user));
    });
    on<AuthenticationUserChangedEvent>((event, emit) {
      if(event.user != null) {
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }

  Future<String?> getUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return user?.uid;
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}