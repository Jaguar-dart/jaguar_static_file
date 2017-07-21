library static_file.src;

import 'dart:async';
import 'dart:io';
import 'dart:collection';

import 'package:jaguar/jaguar.dart';
import 'package:path/path.dart' as p;

part 'handler.dart';

class StaticFile extends Interceptor<Null, Stream<List<int>>, JaguarFile> {
  /// Optionally force charset/encoding
  final String charset;

  static const String file_not_found = "File Not Found";

  const StaticFile({this.charset});

  Null pre(Context ctx) => null;

  Future<Response<Stream<List<int>>>> post(
      Context ctx, Response<JaguarFile> incoming) async {
    File f = new File(incoming.value.filePath);
    if (!await f.exists()) {
      throw new Response(null, statusCode: HttpStatus.NOT_FOUND);
    }

    final Response<Stream<List<int>>> response =
        new Response<Stream<List<int>>>.cloneExceptValue(incoming);
    response.value = await f.openRead();

    String mimeType;

    switch (f.path.split(".").last) {
      case "html":
        mimeType = "text/html";
        break;
      case "js":
        mimeType = "application/javascript";
        break;
      case "css":
        mimeType = "text/css";
        break;
      case "dart":
        mimeType = "application/dart";
        break;
      case "png":
        mimeType = "image/png";
        break;
      case "jpg":
        mimeType = "image/jpeg";
        break;
      case "jpeg":
        mimeType = "image/jpeg";
        break;
      case "gif":
        mimeType = "image/gif";
        break;
      default:
        mimeType = "text/plain";
        break;
    }
    if (mimeType is String) {
      response.headers.mimeType = mimeType;
    }
    if (charset is String) {
      response.headers.charset = charset;
    }
    return response;
  }
}
