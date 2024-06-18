// To parse this JSON data, do
//
//     final poll = pollFromJson(jsonString);

import 'dart:convert';
// import 'dart:ffi';

Poll pollFromJson(String str) => Poll.fromJson(json.decode(str));

String pollToJson(Poll data) => json.encode(data.toJson());

class Poll {
    int ph;
    int ch;
    int orp;
    int temp;
    dynamic error;

    Poll({
        required this.ph,
        required this.ch,
        required this.orp,
        required this.temp,
        required this.error,
    });

    factory Poll.fromJson(Map<String, dynamic> json) => Poll(
        ph: json["PH"].toInt(),
        ch: json["CH"].toInt(),
        orp: json["ORP"].toInt(),
        temp: json["TEMP"].toInt(),
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "PH": ph,
        "CH": ch,
        "ORP": orp,
        "TEMP": temp,
    };
}