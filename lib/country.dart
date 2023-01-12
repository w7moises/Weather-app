import 'dart:convert';

Country countryFromJson(String str) => Country.fromJson(json.decode(str));

String countryToJson(Country? data) => json.encode(data!.toJson());

class Country {
    Country({
        required this.country,
        required this.latitude,
        required this.longitude,
    });

    String country;
    double latitude;
    double longitude;

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        country: json["country"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
    };
}
