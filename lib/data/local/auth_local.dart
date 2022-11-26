import 'package:chatapp_firebase/helper/custom_exception.dart';
import 'package:chatapp_firebase/helper/hive.config.dart';
import 'package:chatapp_firebase/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthLoacal {
  Future<void> saveCurrentUser(AppUser user, String token);

  AppUser? getCurrentUser();

  Box<AppUser> getUserBox();
}

class AuthLocalImpl implements AuthLoacal {
  @override
  Box<AppUser> getUserBox() {
    return Hive.box(HiveConfig.userGGBox);
  }

  @override
  AppUser? getCurrentUser() {
    final userBox = getUserBox();
    return userBox.get(HiveConfig.currentUserKey);
  }

  @override
  Future saveCurrentUser(AppUser user, String token) async {
    try {
      final userBox = getUserBox();
      await const FlutterSecureStorage()
          .write(key: HiveConfig.currentUserKey, value: token);
      userBox.put(HiveConfig.currentUserKey, user);
    } catch (e) {
      throw LocalException(
          LocalException.unableSaveUser, 'Unable Save User: $e');
    }
  }
}
