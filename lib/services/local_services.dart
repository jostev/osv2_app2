// To use
//   Poll? poll;
// getData () async
// {
//   poll = await LocalServices().getPoll();
//   // poll =  pollFromJson(result);
// }

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/poll.dart';

const String baseUrl = 'http://10.1.2.1';

class LocalServices
{
  var client = http.Client();

  //get
  Future<Poll> getPoll() async
  {
    var api = '/poll';
    var url = Uri.parse(baseUrl + api);
    try {
      var response = await client.get(url);
      var json = response.body;
      return pollFromJson(json);
    } catch (e) {
      if (e is SocketException) {
        return Poll(ph: 1, ch: 1, orp: 1, temp: 1, error: "Timeout: $e");
      }
      return Poll(ph: 1, ch: 1, orp: 1, temp: 1, error: "Caught error: $e");
    }
    // var response = await client.get(url);

    // var json = response.body;
    // return pollFromJson(json);
  }

  Future<dynamic> sendPostCommandRequest(int cmd, int cmddata_1, int cmddata_2, int cmddata_3, int cmddata_4, int cmddata_5) async {
    var api = '/cmd';
    var url = Uri.parse(baseUrl + api);

    // Create the data as a JSON object
    var data = {
      'cmd': cmd,
      'cmd_data_1': cmddata_1,
      'cmd_data_2': cmddata_2,
      'cmd_data_3': cmddata_3,
      'cmd_data_4': cmddata_4,
      'cmd_data_5': cmddata_5,
    };

    var payload = json.encode(data);

    var response = await client.post(url, body: payload);

    return response.body;
    
  }

}