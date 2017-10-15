library jaguar_static_file.example;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_static_file/jaguar_static_file.dart';

@Api()
class MyApi {
  @Get(path: '/file')
  @WrapOne(#staticFile)
  JaguarFile getFile(Context ctx) =>
      new JaguarFile(Directory.current.path + "/example/static/file.css");

  @Get(path: '/static/:filename*')
  @WrapOne(#staticFile)
  JaguarFile getDir(Context ctx) => new JaguarFile(
      Directory.current.path + '/example/static/' + ctx.pathParams['filename']);

  StaticFile staticFile(Context ctx) => new StaticFile();
}

Future main() async {
  final server = new Jaguar(port: 8081);
  server.addApiReflected(new MyApi());
  server.addApi(new StaticFileHandler('/public/', new Directory('./example/')));
  await server.serve();
}
