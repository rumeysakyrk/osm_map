import 'package:flutter/material.dart';

class LoginOption extends StatelessWidget {
  const LoginOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Hesabın var mı?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.lightGreen.shade200,
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.lightGreen,
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "GİRİŞ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
