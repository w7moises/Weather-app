import 'package:app_weather/forecast_tile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'country.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

final List<Country> countries = [
    Country(country: "Peru",latitude: -12.0431800,longitude: -77.0282400),
    Country(country: "Estados Unidos",latitude: 38.0000000,longitude: -97.0000000)
  ];

CameraPosition _initialPosition = CameraPosition(
    target: LatLng(countries[i].latitude, countries[i].longitude),
    zoom: 4,
  );  
int i = 0;

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {


  GoogleMapController? _controller;

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
          ),
          countryMap()
        ],
      ),
    );
  }

  Widget countryMap(){
    return Center(
      child: PopupMenuButton<Country>(
        onSelected:(value) => setState(() {
          _currentLocation(value.latitude,value.longitude);
        }),
        icon: const Icon(Icons.airplanemode_active),
        itemBuilder: (BuildContext context) {
            return countries.map((Country country) {
                return PopupMenuItem<Country>(
                    value: country,
                    child: Text(country.country),
                );
              }).toList();
            },
      ),
    );
  }
  void _currentLocation(var latitude, var longitude) async {
   final GoogleMapController? controller = await _controller;
    controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 4,
          ),
    ));
  }
}
