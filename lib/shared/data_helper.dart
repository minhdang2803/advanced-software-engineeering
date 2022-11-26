
import 'package:chatapp_firebase/helper/connection_util.dart';

class DataHelper {
  static Future<bool> checkInternetConnection() async {
    final hasInternet = await ConnectionUtil.hasInternetConnection();
    return hasInternet;
  }
}
