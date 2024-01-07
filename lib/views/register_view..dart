import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools;

import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();

  // untuk awal program
  @override
  void initState() {
    super.initState();
  }

  // untuk akhir program
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false, // suggestion on keyboard
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false, // suggestion on keyboard
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  final userCredential =
                      await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  // ignore: use_build_context_synchronously
                  // go to verify email
                  // Navigator.of(context).pushNamed(
                  //   // I can verify of not
                  //   // If user won't verify, they can go back
                  //   verifyEmailRoute,
                  // );
                  // another way, send directly after register
                  AuthService.firebase().sendEmailVerification();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(
                    // I can verify of not
                    // If user won't verify, they can go back
                    verifyEmailRoute,
                  );
                  devtools.log(userCredential.toString());
                } on WeakPasswordAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: weak password",
                  );
                } on EmailAlreadyInUseAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: email in use",
                  );
                } on InvalidEmailAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: This is invalid email address",
                  );
                } on GenericAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: Failed to register",
                  );
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                // destroy everything on the screen
                // and change it with build function
                // so it needs a new scaffold
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Already registered? log in here!"))
        ],
      ),
    );
  }
}
