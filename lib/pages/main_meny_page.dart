import 'package:chatapp_firebase/bloc/cubit/auth_cubit.dart';
import 'package:chatapp_firebase/bloc/cubit/auth_state.dart';
import 'package:chatapp_firebase/bloc/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          RouteGenerator.pushReplacementNamedUntil(
              context, RouteName.loginScreen,
              predicate: (value) => false);
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Center(
          child: TextButton(
            child: Text('Logout'),
            onPressed: () {
              context.read<AuthCubit>().logoutGoogle();
            },
          ),
        )),
      ),
    );
  }
}
