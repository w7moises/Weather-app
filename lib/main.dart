import 'package:app_weather/forecast_tile_provider.dart';
import 'package:app_weather/type_map.dart';
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
    Country(country: "Japon",latitude: 36.204824,longitude: 138.252924),
    Country(country: "China",latitude: 35.86166,longitude: 104.195397),
    Country(country: "Argentina",latitude: -38.416097,longitude: -63.616672),
    Country(country: "Brasil",latitude: -14.235004,longitude: -51.92528),
    Country(country: "Estados Unidos",latitude: 38.0000000,longitude: -97.0000000),
    Country(country: "España",latitude: 40.463667,longitude: -3.74922),
    Country(country: "Nigeria",latitude: 9.081999,longitude: 8.675277)
];
final List<TypeMap> mapTypes = [
    TypeMap(op:"PAC0", meaning: "Convective precipitation"),
    TypeMap(op:"PR0", meaning: "Precipitation intensity"),
    TypeMap(op:"PA0", meaning: "Accumulated precipitation"),
    TypeMap(op:"PAR0", meaning: "Accumulated precipitation - rain"),
    TypeMap(op:"PAS0", meaning: "Accumulated precipitation - snow"),	
    TypeMap(op:"SD0", meaning: "Depth of snow"),
    TypeMap(op:"WS10", meaning: "Wind speed at an altitude of 10 meters	"),
    TypeMap(op:"WND", meaning: "Joint display of speed wind (color) and wind direction (arrows)"),
    TypeMap(op:"APM", meaning: "Atmospheric pressure on mean sea level"),	
    TypeMap(op:"TA2", meaning: "Air temperature at a height of 2 meters"),
    TypeMap(op:"TD2", meaning: "Temperature of a dew point"),	
    TypeMap(op:"TS0", meaning: "Soil temperature 0-10"),
    TypeMap(op:"TS10", meaning: "Soil temperature >10"),
    TypeMap(op:"HRD0", meaning: "Relative humidity	%"),
    TypeMap(op:"CL", meaning: "Cloudiness	%")
];

CameraPosition _initialPosition = CameraPosition(
    target: LatLng(countries[0].latitude, countries[0].longitude),
    zoom: 4,
  );  

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String _type = "PA0";

  GoogleMapController? _controller;

  Set<TileOverlay> _tileOverlays = {};
  
  DateTime _forecastDate = DateTime.now();

  _initTiles(DateTime dateTime, String type) async {
    final String overlayId = dateTime.millisecondsSinceEpoch.toString();
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: TileOverlayId(overlayId),
      tileProvider: ForecastTileProvider(
        mapType: type,
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
              _initTiles(_forecastDate,_type);
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
                _initTiles(_forecastDate,_type);
              }, 
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white, 
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230,left: 10),
            child: Column(
              children: [
                countryMap(),
                mapType()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget countryMap(){
    return PopupMenuButton<Country>(
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
    );
  }
  Widget mapType(){
    return PopupMenuButton<TypeMap>(
      onSelected:(value) => setState(() {
        _type = value.op;
        _forecastDate = DateTime.now();
        _initTiles(_forecastDate,_type);
      }),
      icon: const Icon(Icons.texture),
      itemBuilder: (BuildContext context) {
          return mapTypes.map((TypeMap typeMap) {
              return PopupMenuItem<TypeMap>(
                  value: typeMap,
                  child: Text(typeMap.meaning),
              );
            }).toList();
          },
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
