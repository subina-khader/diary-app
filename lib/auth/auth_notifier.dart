import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_provider.dart';
import 'auth_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _authService.authStateChanges.listen((user) {
      state = state.copyWith(
        user: user,
        isLoading: false,
        error: null,
      );
    });
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account with this email already exists.';
          break;

        case 'weak-password':
          message = 'Password should be at least 6 characters.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'network-request-failed':
          message = 'No internet connection.';
          break;

        default:
          message = 'Unable to create your account. Please try again.';
      }

      state = state.copyWith(
        isLoading: false,
        error: message,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      await _authService.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'wrong-password':
        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'network-request-failed':
          message = 'No internet connection.';
          break;

        default:
          message = 'Unable to sign in. Please try again.';
      }

      state = state.copyWith(
        isLoading: false,
        error: message,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<bool> resetPassword(String email) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      await _authService.sendPasswordResetEmail(email);

      state = state.copyWith(
        isLoading: false,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'network-request-failed':
          message = 'No internet connection.';
          break;

        default:
          message = 'Unable to send reset email.';
      }

      state = state.copyWith(
        isLoading: false,
        error: message,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );

      return false;
    }
  }
}

final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
  );
});