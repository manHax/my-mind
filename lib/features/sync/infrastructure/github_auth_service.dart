import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../workspace/infrastructure/workspace_repository.dart';

class AuthState {
  final String? accessToken;
  AuthState({this.accessToken});
}

class GithubAuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedToken = prefs.getString('github_token');
    return AuthState(accessToken: savedToken);
  }

  void setToken(String token) {
    ref.read(sharedPreferencesProvider).setString('github_token', token);
    state = AuthState(accessToken: token);
  }
}

final githubAuthNotifierProvider = NotifierProvider<GithubAuthNotifier, AuthState>(GithubAuthNotifier.new);
