import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/material.dart';

import 'dataBase/authentication.dart';
import 'main_page.dart';

class FavoriPage extends StatefulWidget {
  const FavoriPage({Key? key}) : super(key: key);

  @override
  State<FavoriPage> createState() => _FavoriPageState();
}

class _FavoriPageState extends State<FavoriPage> {
  List favs = [];
  List deleted = [];

  Future<void> favCount() async {
    await fs.FirebaseFirestore.instance
        .collection('rotalar')
        .doc(Authentication().userUID)
        .get()
        .then((value) {
      deleted = value["deleted"];
      for (int i = 0; i < value["count"]; i++) {
        setState(() {
          favs.add(value["fav$i"]);
        });
      }
    });
  }

  Future<void> deleteRoad(int x) async {
    setState(() {
      deleted.add(x);
    });

    await fs.FirebaseFirestore.instance
        .collection('rotalar')
        .doc(Authentication().userUID)
        .update({
      "deleted": deleted,
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
        title: const Text(
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
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: favs.length,
                itemBuilder: (context, index) {
                  if (deleted.contains(index)) {
                    return const Text("");
                  } else {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(
                                      geoPoint1: favs[index][0],
                                      geoPoint2: favs[index][1],
                                      RType: favs[index][4])));
                        },
                        leading: Text(
                          "Fav$index",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Point 1",
                                    style: TextStyle(fontSize: 15)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(favs[index][2].toString().split(",")[0],
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Point 2",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(favs[index][3].toString().split(",")[0],
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            )
                          ],
                        ),
                        trailing: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                  deleteRoad(index);
                                
                              },
                              icon:
                                  const Icon(Icons.remove_circle_outline_sharp),
                            )),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
