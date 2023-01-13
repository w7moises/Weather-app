import '../models/country.dart';
import '../models/type_map.dart';

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