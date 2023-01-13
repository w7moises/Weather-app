import 'dart:math';

import 'package:app_weather/components/menu_button.dart';
import 'package:app_weather/components/side_menu.dart';
import 'package:app_weather/forecast_tile_provider.dart';
import 'package:app_weather/models/type_map.dart';
import 'package:app_weather/utils/rive.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rive/rive.dart';
import '../models/country.dart';
import '../utils/data.dart';

CameraPosition _initialPosition = CameraPosition(
    target: LatLng(countries[0].latitude, countries[0].longitude),
    zoom: 4,
  );  

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with SingleTickerProviderStateMixin{
  String _type = "PA0";

  GoogleMapController? _controller;
  Set<TileOverlay> _tileOverlays = {};
  DateTime _forecastDate = DateTime.now();

  late SMIBool isMenuOpen;
  bool isSideMenuClosed = true;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
      setState(() {
        
      });
    });
    animation = Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
    scaleAnimation = Tween<double>(begin: 1,end: 0.8).animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      backgroundColor: Color(0xFF17203A),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed?-288:0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(),  
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value*288, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: GoogleMap(
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
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isSideMenuClosed?0:240,
            curve: Curves.fastOutSlowIn,
            top: 10,
            child: MenuButton(
              riveonInit: (artboard){
                StateMachineController controller =
                          RiveUtils.getRiveController(artboard,
                              stateMachineName: "State Machine");
                isMenuOpen = controller.findSMI("isOpen") as SMIBool;
                isMenuOpen.value = true;
              },
              press: (){
                if(isSideMenuClosed){
                  _animationController.forward();
                }else{
                  _animationController.reverse();
                }
                isMenuOpen.value = !isMenuOpen.value;
                setState(() {
                  isSideMenuClosed = isMenuOpen.value;
                });
              },
            ),
          ),
          /*Positioned(
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
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 350),
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

