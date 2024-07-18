// To use
//   Poll? poll;
// getData () async
// {
//   poll = await LocalServices().getPoll();
//   // poll =  pollFromJson(result);
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:osv2_app2/model/poll.dart';

const String baseUrl = 'http://192.168.4.1';

class LocalServices
{
  var client = http.Client();
  
  //get
  Future<Poll> getPoll() {
    var time = DateTime.now().millisecondsSinceEpoch;
    var api = '/poll';
    var url = Uri.parse(baseUrl + api);
    return client.get(url).then((response) {
      var json = response.body;
      client.close();
      return pollFromJson(json);
    }).catchError((e) {
      if (e is SocketException) {
        return Poll(ph: 1, ch: 1, orp: 1, temp: 1, error: "Timeout: $e", mode: 0);
      }
      return Poll(ph: 1, ch: 1, orp: 1, temp: 1, error: "Caught error: $e", mode: 0);
    });
  }

  Future<dynamic> sendPostCommandRequest(int cmd, int cmddata_1, int cmddata_2, int cmddata_3, int cmddata_4, int cmddata_5) async {
    var api = '/cmd';
    var url = Uri.parse(baseUrl + api);

    // Create the data as a JSON object
    var data = {
      "cmd": cmd.toString(),
      "cmd_data_1": cmddata_1.toString(),
      "cmd_data_2": cmddata_2.toString(),
      "cmd_data_3": cmddata_3.toString(),
      "cmd_data_4": cmddata_4.toString(),
      "cmd_data_5": cmddata_5.toString(),
    };

    var payload = json.encode(data);

    try {
      var response = await client.post(url, body: payload);
      client.close();
      return response.body;
    } on Exception catch (e) {
      print('Caught error: $e');
    }
  }
}