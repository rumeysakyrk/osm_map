import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(51.5, -0.09),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/rmyskyrk/cl5weelpx000115pf8ryau9pp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoicm15c2t5cmsiLCJhIjoiY2w1d2R6OXUyMDQ0cjNvb2FlandhOGNvdSJ9.tJ5Fa2XQUjvu9uxchxhlUg",
                additionalOptions: {
                  'accessToken':'pk.eyJ1Ijoicm15c2t5cmsiLCJhIjoiY2w1d2R6OXUyMDQ0cjNvb2FlandhOGNvdSJ9.tJ5Fa2XQUjvu9uxchxhlUg',
                  'id':'mapbox://styles/rmyskyrk/cl5weelpx000115pf8ryau9pp'
                }
            ),
            MarkerLayerOptions(

            ),
          ],
        )
    );
  }
}
