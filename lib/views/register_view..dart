import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools;

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
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);

                  devtools.log(userCredential.toString());
                } on FirebaseAuthException catch (e) {
                  devtools.log("Ohh Exception catchy");
                  if (e.code == "weak-password") {
                    devtools.log("Your password so weak");
                  } // invalid-credential
                  else if (e.code == "email-already-in-use") {
                    devtools.log("Your email is exist already");
                  } else if (e.code == "invalid-email") {
                    devtools.log("Your email is invalid");
                  }
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
