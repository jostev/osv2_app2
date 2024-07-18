// To parse this JSON data, do
//
//     final poll = pollFromJson(jsonString);

import 'dart:convert';

// import 'dart:ffi';

Poll pollFromJson(String str) => Poll.fromJson(json.decode(str));

String pollToJson(Poll data) => json.encode(data.toJson());

class Poll {
    double ph;
    double ch;
    int orp;
    double temp;
    dynamic error;
    int mode;

    Poll({
        required this.ph,
        required this.ch,
        required this.orp,
        required this.temp,
        required this.error,
        required this.mode,
    });

    factory Poll.fromJson(Map<String, dynamic> json) => Poll(
        ph: int.parse(json["PH"])/100,
        ch: double.parse(json["CH"]),
        orp: int.parse(json["ORP"]), // - 32768
        temp: double.parse(json["TEMP"]),
        error: json["error"],
        mode: int.parse(json["MODE"]),
    );

    Map<String, dynamic> toJson() => {
        "PH": ph,
        "CH": ch,
        "ORP": orp,
        "TEMP": temp,
        "MODE": mode
    };
}