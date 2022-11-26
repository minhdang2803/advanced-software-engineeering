import 'package:chatapp_firebase/helper/custom_exception.dart';
import 'package:chatapp_firebase/helper/share_preferences.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/shared/data_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemote {
  Future<bool> loginWithGoogle();
  // Future<void> loginWithApple();
  Future<bool> registerWithEmail(
      {required String email,
      required String password,
      required String fullname});
  Future<bool> loginWithEmail(String email, String password);
  Future<void> logoutGoogle();
}

class AuthRemoteImpl implements AuthRemote {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  @override
  Future<bool> loginWithEmail(String email, String password) async {
    if (!await DataHelper.checkInternetConnection()) {
      throw RemoteException(
          RemoteException.noInternet, 'No Internet Connection');
    }
    bool result = true;
    if (email == '' || password == '') {
      return Future.value(false);
    }
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      SharedPrefWrapper.instance.setBool('isLoggedIn', true);
    }).catchError((error) {
      result = false;
      throw RemoteException(RemoteException.other, error.code);
    });
    return Future.value(result);
  }

  @override
  Future<void> logoutGoogle() async {
    final userData =
        FirebaseAuth.instance.currentUser?.providerData[0].providerId;
    if (userData != 'password') {
      await googleSignIn.disconnect().catchError(() {});
    }
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<bool> loginWithGoogle() async {
    if (!await DataHelper.checkInternetConnection()) {
      throw RemoteException(
          RemoteException.noInternet, 'No Internet Connection');
    }
    final googleUser = await googleSignIn.signIn().catchError((error) {
      throw RemoteException(RemoteException.other, error.code);
    });
    _user = googleUser;
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() async {
        final user = FirebaseAuth.instance.currentUser!;
        await DatabaseService(uid: user.uid)
            .savingUserData(user.displayName!, user.email!);
        FirebaseAuth.instance.currentUser!.updateDisplayName(user.displayName);
      });
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<bool> registerWithEmail(
      {required String email,
      required String password,
      required String fullname}) async {
    bool result = true;
    if (!await DataHelper.checkInternetConnection()) {
      throw RemoteException(
          RemoteException.noInternet, 'No Internet Connection');
    }
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await DatabaseService(uid: uid).savingUserData(fullname, email);
      FirebaseAuth.instance.currentUser!.updateDisplayName(fullname);
    }).catchError((error) {
      result = false;
      throw RemoteException(RemoteException.other, error);
    });

    FirebaseAuth.instance.currentUser!.updateDisplayName(fullname);
    return Future.value(result);
  }
}
