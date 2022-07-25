import 'package:flutter/material.dart';

class Login_SignUp extends StatefulWidget
{
  const Login_SignUp({Key? key}) : super(key: key);

  @override
  State<Login_SignUp> createState() => _Login_SignUpState();
}

class _Login_SignUpState extends State<Login_SignUp> {
  final _formKey = GlobalKey<FormState>();
  //controller editings
  final emailEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final emailField= TextFormField(
    autofocus: false,
    keyboardType: TextInputType.emailAddress,
    controller: emailEditingController,
    onSaved: (value) {
      emailEditingController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: 'Email',
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
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
      hintText: 'Password',
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
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
      hintText: 'Confirm Pasword',
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
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
  );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Sign up with",
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
      SizedBox(
        height: 16,
      ),
      emailField,
      SizedBox(height: 16,),
      passwordField,
      SizedBox(height: 16,),
      confirmPasswordField,
      SizedBox(
        height: 24,
      ),
      Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0,3),
            ),
          ],
        ),
        child: Center(
          child: TextButton(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
              }
          ),
        ),
      ),


    ],
  );
  }
}
