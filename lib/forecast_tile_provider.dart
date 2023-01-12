
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ForecastTileProvider implements TileProvider{
  final String mapType;
  final double opacity;
  final DateTime dateTime;
  int tileSize = 256;

  ForecastTileProvider({
    required this.mapType,
    required this.opacity,
    required this.dateTime
    });

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List tileBytes = Uint8List(0);
    final date = dateTime.millisecondsSinceEpoch ~/ 1000;

    try {
      final url = "http://maps.openweathermap.org/maps/2.0/weather/$mapType/$zoom/$x/$y?date=$date&opacity=$opacity&appid=9de243494c0b295cca9337e1e96b00e2";
      final uri = Uri.parse(url);
      final imageData = await NetworkAssetBundle(uri).load("");
      print("$zoom/$x/$y");
      tileBytes = imageData.buffer.asUint8List();
    } catch (e) {
      print(e.toString());
    }
    return Tile(tileSize,tileSize, tileBytes);
  }
}