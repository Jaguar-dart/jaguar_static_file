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

  const WrapStaticFile(
      {this.charset: 'utf-8', this.encoding: UTF8, this.id, this.makeParams});

  StaticFile createInterceptor() =>
      new StaticFile(charset: charset, encoding: encoding);
}

class StaticFile extends Interceptor {
  final String charset;
  final Encoding encoding;

  static const String file_not_found = "File Not Found";

  const StaticFile({this.charset: 'utf-8', this.encoding: UTF8});

  @InputRouteResponse()
  Future<Response<Stream>> post(Response<JaguarFile> incoming) async {
    File f = new File(incoming.value.filePath);
    if (!await f.exists()) {
      throw new JaguarError(404, file_not_found, file_not_found);
    }

    //  TODO: add more content-type

    final Response<Stream> response =
        new Response<Stream>.cloneExceptValue(incoming);
    response.value = await f.openRead();

    String contentType;

    switch (f.path.split(".").last) {
      case "html":
        contentType += "text/html;";
        break;
      case "js":
        contentType += "application/javascript;";
        break;
      case "css":
        contentType += "text/css;";
        break;
      case "dart":
        contentType += "application/dart;";
        break;
      case "png":
        contentType += "image/png;";
        break;
      case "jpg":
        contentType += "image/jpeg;";
        break;
      case "jpeg":
        contentType += "image/jpeg;";
        break;
      case "gif":
        contentType += "image/gif;";
        break;
      default:
        contentType += "text/plain;";
        break;
    }
    contentType += " charset=$charset;";
    response.setContentType(contentType);
    return response;
  }
}
