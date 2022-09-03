import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final _fireAuth = FirebaseAuth.instance;

  String get userUID => _fireAuth.currentUser!.uid;

  // String? get mail => _fireAuth.currentUser!.email;
  Future<String> logIn(String email, String password) async {
    try {
      UserCredential userCreds = await _fireAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance
          .collection('lists')
          .doc(userUID)
          .update({'status': 1});
      return 'true';
    } catch (e) {
      return e.toString() ==
              "[firebase_auth/unknown] Given String is empty or null"
          ? "Verilen Dize boş.\nBoşlukları Doldurun!"
          : (e.toString() ==
                  "[firebase_auth/invalid-email] The email address is badly formatted."
              ? "E-posta adresi hatalı biçimlendirilmiş.\nTekrar deneyin!"
              : (e.toString() ==
                      "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."
                  ? "Parola geçersiz veya kullanıcının parolası yok!"
                  : (e.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."
                      ? "Bu tanımlayıcıya karşılık gelen kullanıcı kaydı yok.\n\nKullanıcı silinmiş olabilir!"
                      : (e.toString() ==
                              "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later."
                          ? "Olağandışı etkinlik nedeniyle bu cihazdan gelen tüm istekleri engelledik.\n\nDaha sonra tekrar deneyin!!"
                          : "Bir şeyler ters gitti.\n\nTekrar deneyin!!"))));
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      UserCredential userCreds = await _fireAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'true';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Zayıf şifre, daha güçlü bir şifre deneyin!';
      } else if (e.code == 'email-already-in-use') {
        return 'E-posta daha önce kullanılmış.';
      } else {
        return e.message!;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      await _fireAuth.sendPasswordResetEmail(email: email);
      return 'true';
    } catch (e) {
      return e.toString() ==
              "[firebase_auth/unknown] Given String is empty or null"
          ? "Verilen Dize boş.\nBoşlukları Doldurun!"
          : (e.toString() ==
                  "[firebase_auth/invalid-email] The email address is badly formatted."
              ? "E-posta adresi hatalı biçimlendirilmiş.\nTekrar deneyin!"
              : (e.toString() ==
                      "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."
                  ? "Parola geçersiz veya kullanıcının parolası yok!"
                  : (e.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."
                      ? "Bu tanımlayıcıya karşılık gelen kullanıcı kaydı yok.\n\nKullanıcı silinmiş olabilir!"
                      : (e.toString() ==
                              "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later."
                          ? "Olağandışı etkinlik nedeniyle bu cihazdan gelen tüm istekleri engelledik.\n\nDaha sonra tekrar deneyin!!"
                          : "Bir şeyler ters gitti.\n\nTekrar deneyin!!"))));
    }
  }

  Future<String> logOut() async {
    try {
      await _fireAuth.signOut();
      return 'true';
    } catch (e) {
      return e.toString();
    }
  }
}
