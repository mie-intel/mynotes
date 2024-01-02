import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:mynotes/firebase_options.dart";

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
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          print("Ohh Exception catchy");
                          print(e.code); // invalid-credential
                          if (e.code == "invalid-credential") {
                            print("user not found!");
                          } else {
                            print("Something Else Happen");
                          }
                        } catch (e) {
                          print("Somethin' bad happen");
                          print(e.runtimeType); // show class
                          print(e);
                        }
                      },
                      child: const Text('Login')),
                ],
              );
            default:
              return const Text("Loading");
          }
          // snapshot -> the result of the future
        },
      ),
    );
  }
}
