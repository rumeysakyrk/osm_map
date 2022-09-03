import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps_login_ui/main_page.dart';
import '../dataBase/firestore_data.dart';
import '../dataBase/authentication.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  //controller editings
  final emailEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      controller: emailEditingController,
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'E-Mail',
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      controller: passwordEditingController,
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Şifre',
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
    final confirmPasswordField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      controller: confirmPasswordEditingController,
      obscureText: true,
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Şifre(Tekrar)',
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Hesap oluştur",
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 2,
              fontWeight: FontWeight.w500),
        ),
        const Text(
          "maPolestar",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        emailField,
        const SizedBox(
          height: 16,
        ),
        passwordField,
        const SizedBox(
          height: 16,
        ),
        confirmPasswordField,
        const SizedBox(
          height: 24,
        ),
        Container(
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: TextButton(
                child: const Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  if (passwordEditingController.text ==
                      confirmPasswordEditingController.text) {
                    String signUpping = await Authentication().signUp(
                        emailEditingController.text,
                        passwordEditingController.text);
                    if (signUpping == 'true') {
                      FireStore().addUser(password: ' ', email: '');
                      FirebaseFirestore.instance
                          .collection('rotalar')
                          .doc(Authentication().userUID)
                          .set({'count': 0,'deleted':[]});
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return MainPage(
                            signed: true,
                          );
                        },
                      ), (route) => false);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(signUpping),
                          );
                        },
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text(
                              'Onay şifresi eşleşmiyor.\n\n Şifrelerin aynı olduğundan emin olun.'),
                        );
                      },
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
