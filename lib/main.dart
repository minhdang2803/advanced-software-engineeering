import 'package:chatapp_firebase/bloc/cubit/auth_cubit.dart';
import 'package:chatapp_firebase/bloc/router.dart';
import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/helper/hive.config.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/chat_list_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig().init();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  final initRoute = await HiveConfig.getInitialRoute();
  runApp(FastDoc(initialRoute: initRoute));
}

class FastDoc extends StatefulWidget {
  const FastDoc({Key? key, required this.initialRoute}) : super(key: key);
  final String initialRoute;
  @override
  State<FastDoc> createState() => _FastDocState();
}

class _FastDocState extends State<FastDoc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthCubit())],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Constants().primaryColor,
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        initialRoute: widget.initialRoute,
        onGenerateRoute: RouteGenerator.onGenerateAppRoute,
      ),
    );
  }
}
