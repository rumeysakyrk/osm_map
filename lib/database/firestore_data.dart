import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'authentication.dart';

class FireStore {

   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(
      {
        required String email,
        required String password}) async {
    String uids = Authentication().userUID;
    _firebaseFirestore.collection('users').doc(uids).set(
      {
        'email': email,
        'password': password,
      },
    );
  }
}