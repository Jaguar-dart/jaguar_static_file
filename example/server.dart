library jaguar_static_file.example;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_static_file/jaguar_static_file.dart';

@Api()
class MyApi {
  @Get(path: '/file')
  @WrapOne(#staticFile)
  JaguarFile getFile(Context ctx) =>
      new JaguarFile(Directory.current.path + "/static/file.css");

  @Get(path: '/static/:filename*')
  @WrapOne(#staticFile)
  JaguarFile getDir(Context ctx) => new JaguarFile(
      Directory.current.path + '/static/' + ctx.pathParams['filename']);

  StaticFile staticFile(Context ctx) => new StaticFile();
}

Future main() async {
  final server = new Jaguar();
  server.addApi(reflectJaguar(new MyApi()));
  await server.serve();
}