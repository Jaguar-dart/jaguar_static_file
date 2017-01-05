library static_file.src;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:jaguar/jaguar.dart';

class WrapStaticFile implements RouteWrapper<StaticFile> {
  final String charset;
  final Encoding encoding;

  final String id;
  final Map<Symbol, MakeParam> makeParams;

  const WrapStaticFile({this.charset: 'utf-8', this.encoding: UTF8, this.id, this.makeParams});

  StaticFile createInterceptor() => new StaticFile(charset: charset, encoding: encoding);
}

class StaticFile extends Interceptor {
  final String charset;
  final Encoding encoding;

  const StaticFile({this.charset: 'utf-8', this.encoding: UTF8});

  @InputRouteResponse()
  Future<Response<dynamic>> post(Response<JaguarFile> response) async {
    File f = new File(response.value.filePath);
    if (!await f.exists()) {
      return new Response<String>("Not Found", statusCode: 404);
    }
    Map<String, String> headers = {};
    //  TODO: add more content-type

    switch (f.path.split(".").last) {
      case "html":
        headers['Content-Type'] = "text/html;";
        break;
      case "js":
        headers['Content-Type'] = "application/javascript;";
        break;
      case "css":
        headers['Content-Type'] = "text/css;";
        break;
      case "dart":
        headers['Content-Type'] = "application/dart;";
        break;
      case "png":
        headers['Content-Type'] = "image/png;";
        break;
      case "jpg":
        headers['Content-Type'] = "image/jpeg;";
        break;
      case "jpeg":
        headers['Content-Type'] = "image/jpeg;";
        break;
      case "gif":
        headers['Content-Type'] = "image/gif;";
        break;
      default:
        headers['Content-Type'] = "text/plain;";
    }
    headers['Content-Type'] += " charset=$charset;";
    return new Response<Stream>(await f.openRead(), statusCode: 200, headers: headers);
  }
}
