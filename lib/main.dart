import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view..dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log; // import specific function

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    // Map <string, builder>
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        // expected to return a widget iin builder
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // Get current user
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('Hello world!');
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
        // snapshot -> the result of the future
      },
    );
  }
}

/*
  print(user);
  if (user?.emailVerified ?? false) {
    // print("You are verified");
    return const Text("Done");
  } else {
    // print("You need to verified first!");
    // numpuk jadi stack
    //Navigator.of(context).push(MaterialPageRoute(
    //    builder: (context) => const VerifyEmailView()));
    // cuman ngereturn contentnya aja
    return const VerifyEmailView();
  }
  -> after verify, just log in once more to make sure
   firebase update it's database
*/