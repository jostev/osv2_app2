import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:osv2_app2/model/poll.dart';
import 'dart:async';

import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:osv2_app2/services/local_services.dart';

Future<String> get _localPath async {
  final directory = await getApplicationCacheDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  final devInfo = await LocalServices().getInfo();
  var addressList = devInfo.address.split(':');
  var address = addressList[3] + addressList[4] + addressList[5];

  return File('$path/Osv2$address.csv');
}

Future<File> writeCSV(Poll poll) async {
  final file = await _localFile;
  final time = DateTime.now();
  List<String> dateTime = time.toString().split(' ');
  String writeStr ="";// "${dateTime[0]},${dateTime[1]},${poll.ph},${poll.orp},${poll.ch}";

  if (await file.readAsString() == "") writeStr = "date,time,ph,orp,ch\n";

  if (poll.error != null) {
    writeStr = "\n${dateTime[0]},${dateTime[1]},${poll.error},,,";
    return file.writeAsString(
      writeStr,
      mode: FileMode.append
    );
  }

  writeStr += "\n${dateTime[0]},${dateTime[1]},${poll.ph},${poll.orp},${poll.ch}";

  return file.writeAsString(
    writeStr,
    mode: FileMode.append
  );
}

Future<File> initWriteCSV() async {
  final file = await _localFile;
  return file.writeAsString("date,time,ph,orp,ch");
}

void printCSV() async {
  final file = await _localFile;

  final contents = await file.readAsString();
  print("CONTENTS: $contents\nPATH: ${file.path}"); 
}

void sendMail() async {
  // final path = await _localPath;
  final file = await _localFile;
  final MailOptions mailOptions = MailOptions(
    body: "Recorded ph, orp, and ch values.",
    subject: "MineralSwim Pool Readings",
    recipients: ['example@example.com'],
    isHTML: true,
    attachments: [file.path],
  );
  final MailerResponse response = await FlutterMailer.send(mailOptions);
  // if (response == MailerResponse.android) { print("success"); }
}




