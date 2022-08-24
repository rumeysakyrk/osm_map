import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maps_login_ui/database/authentication.dart';
import 'dart:math';
import 'favoriPage.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RoadType rType=RoadType.car;
  double value = 0;
  bool chooseButton = true;
  late MapController controller;
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(true);
  late GlobalKey<ScaffoldState> scaffoldKey;

  bool hasRoad = false;
  late TextEditingController textEditingController = TextEditingController();
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);
  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = const Key("streamAddressSug");

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: 5,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  void textOnChanged() async {
    final v = textEditingController.text;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(const Duration(seconds: 2), (timer) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  int x = 0;
  Future favCount() async {
    await fs.FirebaseFirestore.instance
        .collection('rotalar')
        .doc(Authentication().userUID)
        .get()
        .then((value) {
      x = value["count"];
    });
    return x;
  }

  @override
  void initState() {
    Km = "-";
    duration = "-";
    textEditingController.addListener(textOnChanged);
    value = 0;
    super.initState();
    controller = MapController(
      initMapWithUserPosition: true,
      initPosition: GeoPoint(
        latitude: 42.4358055,
        longitude: 40.4737324,
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  void roadActionBt(GeoPoint point1, GeoPoint point2, RoadType type) async {
    rType=type;
    try {
      await controller.removeLastRoad();
      showFab.value = true;

      RoadInfo roadInformation = await controller.drawRoad(
        point1,
        point2,
        roadType: type,
        roadOption: const RoadOption(
          roadWidth: 10,
          roadColor: Colors.blue,
          showMarkerOfPOI: true,
          zoomInto: true,
        ),
      );
      setState(() {
        duration = Duration(seconds: roadInformation.duration!.toInt())
            .inMinutes
            .toString();
        Km = roadInformation.distance!.floorToDouble().toString();
        hasRoad = true;
      });

      print(
          "duration:${Duration(seconds: roadInformation.duration!.toInt()).inHours}");
      print("distance:${roadInformation.distance}Km");
      print(roadInformation.route.length);
    } on RoadException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${e.errorMessage()}",
          ),
        ),
      );
    }
  }

  void deleteRoad(GeoPoint point1, GeoPoint point2) async {
    await controller.removeLastRoad();
    showFab.value = true;
    controller.removeMarker(point1);
    controller.removeMarker(point2);

    setState(() {
      hasRoad = false;
      Km = "-";
      duration = "-";
    });
  }

  int count = 0;
  late String duration = "-", Km = "-";
  GeoPoint point1 = GeoPoint(latitude: 42, longitude: 40);
  GeoPoint point2 = GeoPoint(latitude: 42, longitude: 40);
  String address1 = "";
  String address2 = "";
  IconData iconFav = Icons.favorite_border_outlined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        backgroundColor: Colors.lightGreen.shade300,
        actions: [
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          value = (value + 1) % 2;
                          chooseButton = true;
                        });
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                      onPressed: () =>
                          roadActionBt(point1, point2, RoadType.car),
                      icon: const Icon(Icons.car_crash,
                          size: 25, color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () =>
                            roadActionBt(point1, point2, RoadType.bike),
                        icon: const Icon(Icons.pedal_bike,
                            size: 25, color: Colors.white)),
                    IconButton(
                      onPressed: () =>
                          roadActionBt(point1, point2, RoadType.foot),
                      icon: const Icon(Icons.directions_walk,
                          size: 25, color: Colors.white),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          value = (value + 1) % 2;
                          chooseButton = false;
                        });
                      },
                      icon: const Icon(
                        Icons.menu_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    duration != "-"
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                if (iconFav == Icons.favorite_border_outlined) {
                                  fs.FirebaseFirestore.instance
                                      .collection('rotalar')
                                      .doc(Authentication().userUID)
                                      .update({
                                    "fav$x": [
                                      fs.GeoPoint(
                                          point1.latitude, point1.longitude),
                                      fs.GeoPoint(
                                          point2.latitude, point2.longitude),
                                      address1,address2,rType.toString()
                                    ],
                                    "count": x + 1
                                  });
                                  iconFav = Icons.favorite_outlined;
                                  x++;
                                } else {
                                  iconFav = Icons.favorite_border_outlined;
                                }
                              });
                            },
                            icon: Icon(
                              iconFav,
                              size: 25,
                              color: Colors.white,
                            ))
                        : Text(""),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      "Süre: " + duration + "  ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("Km: " + Km, style: TextStyle(fontSize: 16)),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star_border_outlined,
                          size: 25,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, Colors.lightGreen.shade300],
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
                    chooseButton == true
                        ? TextField(
                            controller: textEditingController,
                            onEditingComplete: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.lightGreen.shade300,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              suffix: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: textEditingController,
                                builder: (ctx, text, child) {
                                  if (text.text.isNotEmpty) {
                                    return child!;
                                  }
                                  return SizedBox.shrink();
                                },
                                child: InkWell(
                                  focusNode: FocusNode(),
                                  onTap: () {
                                    textEditingController.clear();

                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              focusColor: Colors.black,
                              hintText: "Ara",
                            ),
                          )
                        : Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.favorite),
                                  title: Text('Favori Rotalar'),
                                  onTap: ()  {Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return favoriPage();
                                        },
                                      ), (route) => false);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.star),
                                  title: Text(
                                    'Gidilecek Rotalar',
                                  ),
                                  onTap: () => {Navigator.of(context).pop()},
                                ),
                                ListTile(
                                  leading: Icon(Icons.exit_to_app),
                                  title: Text('Çıkış'),
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
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: StreamBuilder<List<SearchInfo>>(
                          stream: streamSuggestion.stream,
                          key: streamKey,
                          builder: (ctx, snap) {
                            if (snap.hasData) {
                              return chooseButton == true
                                  ? ListView.builder(
                                      itemExtent: 50.0,
                                      itemBuilder: (ctx, index) {
                                        return ListTile(
                                          title: Text(
                                            snap.data![index].address
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                          ),
                                          onTap: () async {
                                            if (count < 2) {
                                              if (count == -5) {
                                                setState(() {
                                                  controller
                                                      .removeMarker(point1);
                                                  address1 = snap
                                                      .data![index].address
                                                      .toString();
                                                });
                                                count = 1;
                                                point1 =
                                                    snap.data![index].point!;
                                              } else if (count == 0) {
                                                setState(() {
                                                  address1 = snap
                                                      .data![index].address
                                                      .toString();
                                                });
                                                point1 =
                                                    snap.data![index].point!;
                                              } else {
                                                setState(() {
                                                  address2 = snap
                                                      .data![index].address
                                                      .toString();
                                                });
                                                point2 =
                                                    snap.data![index].point!;
                                              }
                                              setState(() {
                                                count++;
                                              });
                                              controller.addMarker(
                                                  snap.data![index].point!);
                                              controller.goToLocation(
                                                snap.data![index].point!,
                                              );
                                              controller.setZoom(zoomLevel: 20);

                                              notifierAutoCompletion.value =
                                                  false;
                                              await reInitStream();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                FocusNode(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      itemCount: snap.data!.length,
                                    )
                                  : Text("");
                            }
                            return const SizedBox();
                          }),
                    ),
                  ],
                ))),
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
                  body: Stack(
                    children: [
                      Expanded(
                        child: OSMFlutter(
                          controller: controller,
                          trackMyPosition: false,
                          minZoomLevel: 2,
                          maxZoomLevel: 18,
                          userLocationMarker: UserLocationMaker(
                            personMarker: MarkerIcon(
                              icon: Icon(
                                Icons.cached,
                                color: Colors.red,
                                size: 70,
                              ),
                            ),
                            directionArrowMarker: MarkerIcon(
                              icon: Icon(
                                Icons.location_history_rounded,
                                color: Colors.red,
                                size: 70,
                              ),
                            ),
                          ),
                        ),
                      ),
                      count >= 1
                          ? Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        count = -5;
                                        value = 1;
                                        chooseButton = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.amber[50],
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Text(
                                        address1,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        value = 1;
                                        count = 1;
                                        controller.removeMarker(point2);
                                        chooseButton = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.amber[50],
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        count == 2 || count == -5
                                            ? address2
                                            : "",
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Text(""),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.lightGreen.shade300,
                    onPressed: () async {
                      if (!hasRoad) {
                        if (!trackingNotifier.value) {
                          await controller.currentLocation();
                          await controller.enableTracking();
                        } else {
                          await controller.disabledTracking();
                        }
                        trackingNotifier.value = !trackingNotifier.value;
                      } else {
                        deleteRoad(point1, point2);
                        count = 0;
                      }
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: trackingNotifier,
                      builder: (ctx, isTracking, _) {
                        if (!hasRoad) {
                          if (isTracking) {
                            return const Icon(Icons.gps_off_sharp);
                          }
                          return const Icon(Icons.my_location);
                        }
                        return const Icon(Icons.clear);
                      },
                    ),
                  ),
                ),
              );
            }),
      ]),
    );
  }
}
