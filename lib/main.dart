import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view..dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    // Map <string, builder>
    routes: {
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegisterView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        // expected to return a widget iin builder
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // Get current user
            final user = FirebaseAuth.instance.currentUser;

            // print(user);
            // if (user?.emailVerified ?? false) {
            //   // print("You are verified");
            //   return const Text("Done");
            // } else {
            //   // print("You need to verified first!");
            //   // numpuk jadi stack
            //   //Navigator.of(context).push(MaterialPageRoute(
            //   //    builder: (context) => const VerifyEmailView()));
            //   // cuman ngereturn contentnya aja
            //   return const VerifyEmailView();
            // }
            // -> after verify, just log in once more to make sure
            /// firebase update it's database

            if (user != null) {
              if (user.emailVerified) {
                print("Email is verified");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

            return const Text("Done");
          default:
            return const CircularProgressIndicator();
        }
        // snapshot -> the result of the future
      },
    );
  }
}
