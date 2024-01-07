import "package:flutter/material.dart";
import "package:mynotes/constants/routes.dart";
import "package:mynotes/services/auth/auth_exceptions.dart";
import "package:mynotes/services/auth/auth_service.dart";
import "dart:developer" as devtools;
import "package:mynotes/utilities/show_error_dialog.dart";

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Statefull widget need to have build function
class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text("Login")),
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
                  // final userCredential =
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );

                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    // user's email is verified
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    // user's email is not verified
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on UserNotFoundAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: User not found!",
                  );
                } on WrongPasswordAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: Wrong credentials!",
                  );
                } on GenericAuthException {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Error: Authentification Error!",
                  );
                }
              },
              child: const Text('Login')),
          TextButton(
            onPressed: () {
              // destroy everything on the screen
              // and change it with build function
              // so it needs a new scaffold
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) =>
                    false, // remove everything. don't care about the routes.
                // just go to the register view
              );
            },
            child: const Text("Not registered yet? Register here!"),
          )
        ],
      ),
    );
  }
}
