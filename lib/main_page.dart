import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:math';
import 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double value = 0;
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
  String address1="";
  String address2="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130.0,
        backgroundColor: Colors.lightGreen.shade300,
        actions: [
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () { setState(() {
                        value = (value + 1) % 2;
                      });},
                      icon: const  Icon(
                        Icons.menu_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _signOut();
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ), (route) => false);
                      },
                      icon:const Icon(
                        Icons.logout
                      )
                    )

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => roadActionBt(point1, point2, RoadType.car),
                      icon: const Icon(Icons.car_crash),
                    ),
                    IconButton(
                        onPressed: () =>
                            roadActionBt(point1, point2, RoadType.bike),
                        icon: const Icon(Icons.pedal_bike)),
                    IconButton(
                      onPressed: () =>
                          roadActionBt(point1, point2, RoadType.foot),
                      icon: const Icon(Icons.directions_walk),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Süre: " + duration + "  ", style: TextStyle(fontSize: 16),),SizedBox(width: 25,), Text("Km: " + Km, style: TextStyle(fontSize: 16))],
                )
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
                      "maPolestar",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              TextField(
                controller: textEditingController,
                onEditingComplete: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
              ),
              SizedBox(height: 20,),
              Expanded(
                child:  StreamBuilder<List<SearchInfo>>(
                    stream: streamSuggestion.stream,
                    key: streamKey,
                    builder: (ctx, snap) {
                      if (snap.hasData) {
                        return ListView.builder(
                          itemExtent: 50.0,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              title: Text(
                                snap.data![index].address.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),
                              onTap: () async {
                                if (count < 2) {
                                  if (count == -5) {
                                    setState(() {
                                      controller.removeMarker(point1);
                                      address1 =
                                          snap.data![index].address.toString();
                                    });
                                    count = 1;
                                    point1 = snap.data![index].point!;
                                  } else if (count == 0) {
                                    setState(() {
                                      address1 =
                                          snap.data![index].address.toString();
                                    });

                                    point1 = snap.data![index].point!;
                                  } else {
                                    setState(() {
                                      address2 =
                                          snap.data![index].address.toString();
                                    });

                                    point2 = snap.data![index].point!;
                                  }
                                  setState(() {
                                    count++;
                                  });

                                  controller
                                      .addMarker(snap.data![index].point!);
                                  controller.goToLocation(
                                    snap.data![index].point!,
                                  );
                                  controller.setZoom(zoomLevel: 20);

                                  /// hide suggestion card
                                  notifierAutoCompletion.value = false;
                                  await reInitStream();
                                  FocusScope.of(context).requestFocus(
                                    FocusNode(),
                                  );
                                }
                              },
                            );
                          },
                          itemCount: snap.data!.length,
                        );
                      }
                      return const SizedBox();
                    }),
              ),
            ],
          ),
            )),
// vazgeçtim şifreyi zaten göstermiştimn şimdi uğraşasım gelmedi çalışıyor hala orası videomuzun sonuna gelmiş bulunmaktayız yess burada konumum bu kadar işte en son hali bu şekilde ve eng bir hata :)) neyseki burası türkçe amaan
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
                          minZoomLevel : 2,
                          maxZoomLevel : 18,
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
                                  count=1;
                                  controller.removeMarker(point2);
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
                                  count == 2 || count == -5 ? address2 : "" ,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : const Text(""),
                    ],//yüklenmiyor bazen çok sinir bozucu ayyh yazamaadım neyse oluyor sen biliyorsun :))
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
