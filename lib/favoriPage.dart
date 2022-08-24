import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/material.dart';

import 'dataBase/authentication.dart';
import 'main_page.dart';

class favoriPage extends StatefulWidget {
  const favoriPage({Key? key}) : super(key: key);

  @override
  State<favoriPage> createState() => _favoriPageState();
}

class _favoriPageState extends State<favoriPage> {
  List favs = [];

  Future<void> favCount() async {
    await fs.FirebaseFirestore.instance
        .collection('rotalar')
        .doc(Authentication().userUID)
        .get()
        .then((value) {
      print(value["count"]);
      for (int i = 0; i < value["count"]; i++) {
        setState(() {
          print(value["fav$i"]);
          favs.add(value["fav$i"]);
        });
      }
    });
  }

  @override
  void initState() {
    favCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favori Rotalar",
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            ), (route) => false);
          },
          icon: Icon(Icons.arrow_back_sharp),
        ),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: favs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text("Point 1",
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(
                                width: 10,
                              ),

                              Text(favs[index][2].toString().split(",")[0],
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Point 2",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),

                              Text(favs[index][3].toString().split(",")[0],
                                  style: TextStyle(fontSize: 14)),
                            ],
                          )
                        ],
                      ),
                      leading: Text(
                        "Fav$index",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite),
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}