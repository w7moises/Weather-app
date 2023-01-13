import 'dart:convert';

TypeMap typeMapFromJson(String str) => TypeMap.fromJson(json.decode(str));

String typeMapToJson(TypeMap data) => json.encode(data.toJson());

class TypeMap {
    TypeMap({
        required this.op,
        required this.meaning,
    });

    String op;
    String meaning;

    factory TypeMap.fromJson(Map<String, dynamic> json) => TypeMap(
        op: json["op"],
        meaning: json["meaning"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "op": op,
        "meaning": meaning,
    };
}
