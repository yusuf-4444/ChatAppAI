import 'package:chat_app_ai/core/services/api_path.dart';
import 'package:chat_app_ai/core/services/auth_service.dart';
import 'package:chat_app_ai/core/services/firestore_services.dart';
import 'package:chat_app_ai/features/auth/models/user_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServiceImpl _firebaseAuth = AuthServiceImpl();
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  UserDataModel? currentUserData;

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String userName,
  ) async {
    try {
      emit(AuthLoading());
      final result = await _firebaseAuth.registerWithEmailAndPassword(
        email,
        password,
      );

      final currentUser = _firebaseAuth.getCurrentUser();
      if (currentUser == null) {
        emit(AuthError("Registration failed"));
        return;
      }
      final userData = UserDataModel(
        id: currentUser.uid,
        userName: userName,
        email: email,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _firestoreServices.setData(
        path: ApiPath.user(currentUser.uid),
        data: userData.toMap(),
      );

      if (result == true) {
        currentUserData = userData;
        emit(AuthSuccess());
      } else {
        emit(AuthError("Registration failed.. Email is already in use"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.logout();
    emit(AuthInitial());
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(AuthLoading());
      final result = await _firebaseAuth.authenticateWithGoogle();
      if (result) {
        await loadUserData();
        emit(AuthSuccess());
      } else {
        emit(AuthError("Login failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      final result = await _firebaseAuth.loginWithEmailAndPassword(
        email,
        password,
      );
      if (result) {
        await loadUserData();
        emit(AuthSuccess());
      } else {
        emit(AuthError("Login failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loadUserData() async {
    final user = _firebaseAuth.getCurrentUser();
    if (user == null) {
      emit(AuthError('User not found'));
      return;
    }
    try {
      final userData = await _firestoreServices.getDocument(
        path: ApiPath.user(user.uid),
        builder: (data, id) => UserDataModel.fromMap(data),
      );
      currentUserData = userData;
      emit(UserDataLoaded(userData));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<bool> isUserLoggedIn() async {
    final user = _firebaseAuth.getCurrentUser();
    if (user == null) {
      emit(UserNotLoggedIn());
      return false;
    }
    emit(UserLoggedIn());
    return true;
  }
}
