import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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

                  print(userCredential);
                } on FirebaseAuthException catch (e) {
                  print("Ohh Exception catchy");
                  if (e.code == "weak-password") {
                    print("Your password so weak");
                  } // invalid-credential
                  else if (e.code == "email-already-in-use") {
                    print("Your email is exist already");
                  } else if (e.code == "invalid-email") {
                    print("Your email is invalid");
                  }
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                // destroy everything on the screen
                // and change it with build function
                // so it needs a new scaffold
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/login/", (route) => false);
              },
              child: const Text("Already registered? Log in here!"))
        ],
      ),
    );
  }
}
