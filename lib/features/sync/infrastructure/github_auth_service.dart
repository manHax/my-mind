import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String? accessToken;
  AuthState({this.accessToken});
}

class GithubAuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState();

  void setToken(String token) {
    state = AuthState(accessToken: token);
  }
}

final githubAuthNotifierProvider = NotifierProvider<GithubAuthNotifier, AuthState>(GithubAuthNotifier.new);
