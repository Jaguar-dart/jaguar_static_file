library jaguar_static_file.example;

import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_static_file/jaguar_static_file.dart';

@Api()
class MyApi {
  @Get(path: '/file')
  @WrapOne(#staticFile)
  JaguarFile getFile(Context ctx) =>
      new JaguarFile(Directory.current.path + "/test/static/file.css");

  @Get(path: '/static/:filename*')
  @WrapOne(#staticFile)
  JaguarFile getDir(Context ctx) => new JaguarFile(
      Directory.current.path + '/test/static/' + ctx.pathParams['filename']);

  StaticFile staticFile(Context ctx) => new StaticFile();
}

Future main() async {
  group("Static file", () {
    Jaguar server;

    setUpAll(() async {
      server = new Jaguar();
      server.addApiReflected(new MyApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test("Get file", () async {
      Uri uri = new Uri.http('localhost:8080', '/file');
      http.Response response = await http.get(uri);

      expect(
          response.body,
          '''.hello {
    background-color: red;
}''');
      expect(response.statusCode, 200);
    });

    test("Get dir hello1", () async {
      Uri uri = new Uri.http('localhost:8080', '/static/dir/hello1.txt');
      http.Response response = await http.get(uri);

      expect(response.body, 'Hello1 from hello!');
      expect(response.statusCode, 200);
    });

    test("Get dir hello2", () async {
      Uri uri = new Uri.http('localhost:8080', '/static/dir/hello2.txt');
      http.Response response = await http.get(uri);

      expect(response.body, 'Hello2 from hello!');
      expect(response.statusCode, 200);
    });
  });
}
