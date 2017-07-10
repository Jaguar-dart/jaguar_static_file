library jaguar_mux.example.simple.client;

import 'dart:async';

import 'package:http/http.dart' as http;

const String kHostname = 'localhost';

const int kPort = 8080;

final http.Client _client = new http.Client();

Future<Null> printHttpClientResponse(http.Response resp) async {
  print('=========================');
  print("body:");
  print(resp.body);
  print("statusCode:");
  print(resp.statusCode);
  print("headers:");
  print(resp.headers);
  print('=========================');
}

Future<Null> execGetFile() async {
  String url = "http://$kHostname:$kPort/file";
  http.Response resp = await _client.get(url);

  printHttpClientResponse(resp);
}

Future<Null> execGetStaticDirHello1() async {
  String url = "http://$kHostname:$kPort/static/dir/hello1.txt";
  http.Response resp = await _client.get(url);

  printHttpClientResponse(resp);
}

Future<Null> execGetStaticDirHello2() async {
  String url = "http://$kHostname:$kPort/static/dir/hello2.txt";
  http.Response resp = await _client.get(url);

  printHttpClientResponse(resp);
}

main() async {
  await execGetFile();
  await execGetStaticDirHello1();
  await execGetStaticDirHello2();
}
