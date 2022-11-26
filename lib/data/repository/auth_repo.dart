import 'package:chatapp_firebase/data/local/auth_local.dart';
import 'package:chatapp_firebase/data/remote/auth_remote.dart';
import 'package:chatapp_firebase/models/user_model.dart';

abstract class AuthRepository {
  Future<bool> loginWithEmail(String email, String password);
  Future<void> saveCurrentUser(AppUser user, String token);
  Future<bool> loginWithGoogle();
  Future<bool> registerWithEmail(
      String email, String password, String fullname);
  Future<void> logOut();
  AppUser? getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  late final AuthRemote _authRemote;
  late final AuthLoacal _authLoacal;

  AuthRepositoryImpl._privateConstructor() {
    _authLoacal = AuthLocalImpl();
    _authRemote = AuthRemoteImpl();
  }

  static final _instance = AuthRepositoryImpl._privateConstructor();

  factory AuthRepositoryImpl.instance() => _instance;

  @override
  Future<bool> loginWithEmail(String email, String password) async {
    return await _authRemote.loginWithEmail(email, password);
  }

  @override
  Future<void> saveCurrentUser(AppUser user, String token) async {
    await _authLoacal.saveCurrentUser(user, token);
  }

  @override
  Future<bool> loginWithGoogle() async {
    return await _authRemote.loginWithGoogle();
  }

  @override
  Future<void> logOut() async {
    await _authRemote.logoutGoogle();
  }

  @override
  Future<bool> registerWithEmail(
      String email, String password, String fullname) async {
    return await _authRemote.registerWithEmail(
        email: email, password: password, fullname: fullname);
  }

  @override
  AppUser? getCurrentUser() {
    final clm = _authLoacal.getCurrentUser();
    return clm;
  }
}
