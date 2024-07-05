import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:osv2_app2/model/poll.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

Future<String> get _localPath async {
  final directory = await getApplicationCacheDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/poll.csv');
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
  final path = await _localPath;
  final Email email = Email(
    body: "Attached ph, orp, and ch values from 9am, 1pm and 5pm.",
    subject: "Chemical Readings from 9am, 1pm, and 5pm",
    // recipients: ["example@example.com"],
    // cc: ["cc@example.com"],
    // bcc: ["bcc@example.com"],
    attachmentPaths: ["$path/poll.csv"],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
  print("Email sent.");
}