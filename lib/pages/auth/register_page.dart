import 'package:chatapp_firebase/bloc/cubit/auth_cubit.dart';
import 'package:chatapp_firebase/bloc/cubit/auth_state.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pop(context);
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/login2.png"),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create your Account',
                          style: TextStyle(fontSize: 23),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormField(
                        controller: fullName,
                        decoration: textInputDecoration.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {},
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Name cannot be empty";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
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
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),
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
                        child: _buildButton(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: "Already have an account? ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const LoginPage());
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

  Widget _buildButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: ((context, state) {
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
            "Register",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            register();
          },
        );
      }),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().registerWithEmail(
            email: _email.text,
            password: password.text,
            fullname: fullName.text,
          );
    }
  }
}
