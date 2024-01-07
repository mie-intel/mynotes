import 'package:mynotes/services/auth/auth_user.dart';

// return currentUser
// create abstract class to replace firebase class
abstract class AuthProvider {
  AuthUser? get currentUser;
  // If cannot return, throw error
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
