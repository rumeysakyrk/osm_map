import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:math';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double value = 0;
  late MapController controller;
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: true,
      initPosition: GeoPoint(
        latitude: 47.4358055,
        longitude: 8.4737324,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150.0,
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('sağa doğru çekiniz')),
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, Colors.teal],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          )),
        ),
        SafeArea(
            child: Container(
          width: 200,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: (52),
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("images/traveler.PNG"),
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "TravelApp",
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    title: Text("Ana Sayfa",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                  )
                  )],
              )),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    title: Text("Ayarlar",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  )
                ],
              )),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    title: Text("Çıkış",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                  )
                ],
              ))
            ],
          ),
        )),
        TweenAnimationBuilder(
          curve: Curves.easeIn,
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY((pi / 6) * val),
                child: Scaffold(
                  body: OSMFlutter(
                    controller: controller,
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.teal,
                    onPressed: () async {
                      if (!trackingNotifier.value) {
                        await controller.currentLocation();
                        await controller.enableTracking();
                        //await controller.zoom(5.0);
                      } else {
                        await controller.disabledTracking();
                      }
                      trackingNotifier.value = !trackingNotifier.value;
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: trackingNotifier,
                      builder: (ctx, isTracking, _) {
                        if (isTracking) {
                          return Icon(Icons.gps_off_sharp);
                        }
                        return Icon(Icons.my_location);
                      },
                    ),
                  ),
                ),
              );
            }),
        GestureDetector(
          onHorizontalDragUpdate: (e) {
            if (e.delta.dx > 0) {
              setState(() {
                value = 1;
              });
            } else {
              setState(() {
                value = 0;
              });
            }
          },
        )
      ]),
    );
  }
}
