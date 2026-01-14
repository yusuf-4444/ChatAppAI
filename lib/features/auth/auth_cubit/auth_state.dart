part of 'auth_cubit.dart';

class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

final class AuthSuccess extends AuthState {
  AuthSuccess();
}

final class AuthLogoutLoading extends AuthState {}

final class AuthLogoutSuccess extends AuthState {}

final class AuthLogoutError extends AuthState {
  final String message;
  AuthLogoutError(this.message);
}

final class UserDataLoaded extends AuthState {
  final UserDataModel userData;
  UserDataLoaded(this.userData);
}

final class UserNotLoggedIn extends AuthState {}

final class UserLoggedIn extends AuthState {}

final class GoogleLoginLoading extends AuthState {}

final class GoogleLoginError extends AuthState {
  final String message;
  GoogleLoginError(this.message);
}

final class GoogleRegisterLoading extends AuthState {}

final class GoogleRegisterError extends AuthState {
  final String message;
  GoogleRegisterError(this.message);
}
