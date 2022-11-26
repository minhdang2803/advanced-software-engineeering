import 'package:chatapp_firebase/bloc/cubit/auth_state.dart';
import 'package:chatapp_firebase/data/repository/auth_repo.dart';
import 'package:chatapp_firebase/helper/custom_exception.dart';
import 'package:chatapp_firebase/helper/hive.config.dart';
import 'package:chatapp_firebase/models/user_model.dart';
import 'package:chatapp_firebase/shared/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authRepository = AuthRepositoryImpl.instance();

  Future<void> loginWithEmail(String email, String password) async {
    try {
      emit(AuthLoading());
      //Login to Google
      final result = await _authRepository.loginWithEmail(email, password);
      //Check for login successfull
      if (result) {
        final googleUser = FirebaseAuth.instance.currentUser;
        final token = await googleUser!.getIdToken();
        final user = AppUser(
          id: googleUser.uid,
          fullName: googleUser.displayName,
          email: googleUser.email,
          photoUrl: googleUser.photoURL,
        );
        _authRepository.saveCurrentUser(user, token);
        emit(LoginSuccess());
      } else {
        emit(AuthInitial());
      }
    } on PlatformException catch (exception) {
      emit(AuthFail(code: exception.code, error: exception.message));
    } on RemoteException catch (error) {
      emit(AuthFail(error: error.errorMessage.fromGGErrorToError()));
    } on Exception catch (e) {
      final clm = e.toString();
      emit(AuthFail(error: clm));
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(AuthGGLoading());
      final result = await _authRepository.loginWithGoogle();
      if (result) {
        final googleUser = FirebaseAuth.instance.currentUser;
        final token = await googleUser!.getIdToken();
        final user = AppUser(
          id: googleUser.uid,
          fullName: googleUser.displayName,
          email: googleUser.email,
          photoUrl: googleUser.photoURL,
        );
        _authRepository.saveCurrentUser(user, token);
        emit(LoginSuccess());
      } else {
        emit(AuthInitial());
      }
    } on PlatformException catch (exception) {
      emit(AuthFail(code: exception.code, error: exception.message));
    } on RemoteException catch (error) {
      emit(AuthFail(error: error.errorMessage.fromGGErrorToError()));
    } on Exception catch (e) {
      final clm = e.toString();
      emit(AuthFail(error: clm));
    }
  }

  Future<void> logoutGoogle() async {
    await _authRepository.logOut();
    await const FlutterSecureStorage().delete(key: HiveConfig.currentUserKey);
    emit(AuthInitial());
  }

  void sendEmailVerification() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    emit(AuthVerification());
  }

  Future<void> registerWithEmail(
      {required String email,
      required String password,
      required String fullname}) async {
    try {
      emit(AuthLoading());
      //Login to Google
      final result =
          await _authRepository.registerWithEmail(email, password, fullname);
      //Check for login successfull
      if (result) {
        emit(const RegisterSuccess('Successfully register'));
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        await Future.delayed(const Duration(seconds: 3));
        emit(AuthVerification());
      } else {
        emit(AuthInitial());
      }
    } on PlatformException catch (exception) {
      emit(AuthFail(code: exception.code, error: exception.message));
    } on RemoteException catch (error) {
      emit(AuthFail(error: error.errorMessage.fromGGErrorToError()));
    } on Exception catch (e) {
      final clm = e.toString();
      emit(AuthFail(error: clm));
    }
  }
}
