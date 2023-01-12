import 'dart:async';

import 'package:app_weather/forecast_tile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _controller;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-12.0431800, -77.0282400),
    zoom: 4,
  );

  Set<TileOverlay> _tileOverlays = {};
  
  DateTime _forecastDate = DateTime.now();

  _initTiles(DateTime dateTime) async {
    final String overlayId = dateTime.millisecondsSinceEpoch.toString();
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: TileOverlayId(overlayId),
      tileProvider: ForecastTileProvider(
        mapType: 'PA0',
        opacity: 0.5,
        dateTime: dateTime,
        )
      );

    setState(() {
      _tileOverlays = {tileOverlay};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
              _initTiles(_forecastDate);
            },
            tileOverlays: _tileOverlays,
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
              onPressed: _controller == null ? null : (){
                _forecastDate = _forecastDate.subtract(const Duration(hours: 3));
                _initTiles(_forecastDate);
              }, 
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white, 
                )),
          )
        ],
      ),
    );
  }
}
