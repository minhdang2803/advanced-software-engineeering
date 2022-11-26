import 'package:chatapp_firebase/bloc/router.dart';
import 'package:chatapp_firebase/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  // Name of Boxes
  static const String userGGBox = 'user_google_box';
  static const String currentUserKey = 'currentUserKey';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppUserAdapter());
    // Hive.registerAdapter(LocalVocabInfoAdapter());
    // Register for boxes

    // Connect to boxes
    await Hive.openBox<AppUser>(userGGBox);
    // await Hive.openBox(myDictionary);
  }

  static Future<String> getInitialRoute() async {
    final token =
        await const FlutterSecureStorage().read(key: HiveConfig.currentUserKey);
    return token == null ? RouteName.loginScreen : RouteName.homeScreen;
  }

  // static Future<String> getInitialRoute() async {
  //   if (!await SharedPrefWrapper.instance.getBool('1st_install')) {
  //     SharedPrefWrapper.instance.setBool('1st_install', true);
  //     return RouteName.onboardingScreen;
  //   } else {
  //     final token = await SharedPrefWrapper.instance.getBool('isLoggedIn');
  //     return token == false ? RouteName.welcomeScreen : RouteName.homeScreen;
  //   }
  // }
}
