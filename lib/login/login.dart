import 'package:flutter/material.dart';

import '../database/authentication.dart';

import '../main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final myController = TextEditingController();
  final myControllerPw = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Hoşgeldiniz",
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 2,
              fontWeight: FontWeight.w500),
        ),
        Text(
          "TRAVELAPP",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        Text(
          "Devam etmek için lütfen giriş yapınız",
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: myController,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'E-Mail',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.teal.shade200,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: myControllerPw,
          keyboardType: TextInputType.number,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Şifre',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.teal.shade200,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.teal.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal,
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: TextButton(
                child: Text(
                  "GİRİŞ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  var signing = await Authentication()
                      .logIn(myController.text, myControllerPw.text);
                  print(signing);
                  if (signing == 'true') {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MainPage();
                        },
                      ),
                      (route) => false,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(signing),
                        );
                      },
                    );
                  }
                }),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "Şifreni mi Unuttun?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1,
          ),
        ),
      ],
    );
  }
}
