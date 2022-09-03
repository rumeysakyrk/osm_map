import 'package:flutter/material.dart';
import 'package:maps_login_ui/main.dart';
import '../dataBase/authentication.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final myControllerForgotPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/şifremiunuttum.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.3),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        const Text(
                          'E-Mailinizi Giriniz.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: myControllerForgotPw,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "e-mail",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (myControllerForgotPw.text.isNotEmpty) {
                                String forgotPassword = await Authentication()
                                    .forgotPassword(myControllerForgotPw.text);
                                if (forgotPassword == 'true') {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        content: Text(
                                            'E-mail adresine şifre yenilemen için mail gönderildi.'),
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                          forgotPassword,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text('E-mail girin'),
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('Şifre Talebi Gönder'))
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
