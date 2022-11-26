import 'package:chatapp_firebase/bloc/cubit/auth_cubit.dart';
import 'package:chatapp_firebase/bloc/cubit/auth_state.dart';
import 'package:chatapp_firebase/bloc/router.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          RouteGenerator.pushReplacementNamedUntil(
              context, RouteName.homeScreen,
              predicate: (value) => false);
        }
        if (state is AuthFail) {
          final snackBar = SnackBar(
            content: Text(state.error!),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Image.asset('assets/login2.png'),
                      // SvgPicture.asset('assets/login.svg'),
                      const Text(
                        'Login to your Account',
                        style: TextStyle(fontSize: 23),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      SizedBox(
                        child: TextFormField(
                          controller: _email,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {},
                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: _buildSubmitButton(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: "Don't have an account? ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Register here",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  RouteGenerator.pushNamed(
                                      context, RouteName.registerScreen);
                                }),
                        ],
                      )),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: FittedBox(
                child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            )),
          );
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: const Text(
            "Sign In",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            login();
          },
        );
      },
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginWithEmail(_email.text, _password.text);
    }
  }
}


      // setState(() {
      //   _isLoading = true;
      // });
      // await authService
      //     .loginWithUserNameandPassword(email, password)
      //     .then((value) async {
      //   if (value == true) {
      //     QuerySnapshot snapshot =
      //         await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
      //             .gettingUserData(email);
      //     // saving the values to our shared preferences
      //     await HelperFunctions.saveUserLoggedInStatus(true);
      //     await HelperFunctions.saveUserEmailSF(email);
      //     await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
      //     nextScreenReplace(context, const ChatListPage());
      //   } else {
      //     showSnackbar(context, Colors.red, value);
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }
      // });