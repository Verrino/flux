  import "package:firebase_auth/firebase_auth.dart";

  class AuthenticationService {
    static Future<void> login(email, password) async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        print(e);
      }
    }

    static Future<void> register(email, password) async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        print(e);
      }
    }

    static Future<void> logout() async {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        print(e);
      }
    }
  }
