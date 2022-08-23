import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps_login_ui/main_page.dart';

import 'main.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}
Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
       body: Stack(
         children:[
           Container(
             decoration: BoxDecoration(
                 gradient: LinearGradient(
                   colors: [Colors.white, Colors.lightGreen.shade300],
                   begin: Alignment.bottomCenter,
                   end: Alignment.topCenter,
                 )),
           ),
         Container(
           width: 250,
           child: Drawer(
             child: ListView(
               padding: EdgeInsets.zero,
               children: <Widget>[
                 DrawerHeader(
                   child: Column(
                     children: [
                       CircleAvatar(
                           radius: (68),
                           backgroundColor: Colors.white,
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(66),
                             child: Image.asset("images/mapolestar.png"),
                           )),
                     ],
                   ),
                 ),
                 ListTile(
                     leading: Icon(Icons.input),

                     title: Text('Ana Sayfa'),
                     onTap: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const MainPage()),
                       );
                     }),
                 ListTile(
                   leading: Icon(Icons.favorite),
                   title: Text('Favori Gidilen Rotalar'),
                   onTap: () => {Navigator.of(context).pop()},
                 ),
                 ListTile(
                   leading: Icon(Icons.star),
                   title: Text('Gitmek istenilen Rotalar'),
                   onTap: () => {Navigator.of(context).pop()},
                 ),
                 ListTile(
                   leading: Icon(Icons.exit_to_app),
                   title: Text('Logout'),
                   onTap: () {
                     _signOut();
                     Navigator.pushAndRemoveUntil(context,
                         MaterialPageRoute(
                           builder: (context) {
                             return HomePage();
                           },
                         ), (route) => false);
                   },
                 ),
               ],
             ),
           ),
         ),
         ]
       ),
     ));
  }
}
