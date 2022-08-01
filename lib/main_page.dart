import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      body: OSMFlutter(
        controller: controller,
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
