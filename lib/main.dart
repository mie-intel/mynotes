import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/views/login_view.dart';
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
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegisterView(),
      "/notes/": (context) => const NotesView(),
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

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main UI"), actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogOut = await showLogOutDialog(context);
                devtools.log(shouldLogOut.toString());
                if (shouldLogOut) {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/login/",
                    (_) => false,
                  );
                }
                break;
            }
            // warna print-printannya jadi beda
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Log out"),
              )
            ];
          },
        )
      ]),
      body: const Text("Hello world"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text("Log out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                // .pop() -> ngasih return value ke Future
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Log out"),
            )
          ]);
    },
  ).then((value) => value ?? false);
  // to make sure if the showDialog won't return anything, it return false
}
