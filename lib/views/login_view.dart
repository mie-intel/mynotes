import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:mynotes/firebase_options.dart";
import "dart:developer" as devtools;

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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/notes/",
                    (route) => false,
                  );
                  // devtools.log(userCredential.toString());
                } on FirebaseAuthException catch (e) {
                  devtools.log("Ohh Exception catchy");
                  devtools.log(e.code); // invalid-credential
                  if (e.code == "invalid-credential") {
                    devtools.log("user not found!");
                  } else {
                    devtools.log("Something Else Happen");
                  }
                } catch (e) {
                  devtools.log("Somethin' bad happen");
                  devtools.log(e.runtimeType.toString()); // show class
                  devtools.log(e.toString());
                }
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                // destroy everything on the screen
                // and change it with build function
                // so it needs a new scaffold
                Navigator.of(context).pushNamedAndRemoveUntil(
                  "/register/",
                  (route) =>
                      false, // remove everything. don't care about the routes.
                  // just go to the register view
                );
              },
              child: const Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}
