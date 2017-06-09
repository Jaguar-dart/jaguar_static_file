part of static_file.src;

class StaticServer implements RequestHandler {
  final String path;
  final UnmodifiableListView<String> pathSegments;
  final Directory directory;

  StaticServer(this.path, this.directory)
      : pathSegments = new UnmodifiableListView(splitPathToSegments(path)) {}

  bool matches(Uri reqUri) {
    final List<String> reqSegs = reqUri.pathSegments;

    if (reqSegs.length < pathSegments.length) return false;

    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] != reqSegs[i]) return false;
    }

    return true;
  }

  String _getTargetUrl(final Uri reqUri) {
    List<String> segs = reqUri.pathSegments.toList();

    if (pathSegments.length > 0) {
      segs.removeRange(0, pathSegments.length);
    }

    final ctx = new p.Context();
    final path = ctx.join(directory.absolute.path, ctx.joinAll(segs));

    return path;
  }

  Future<Response<Stream<List<int>>>> handleRequest(Request req,
      {String prefix}) async {
    if (!matches(req.uri)) {
      return null;
    }

    final String path = _getTargetUrl(req.uri);

    File f = new File(path);
    if (!await f.exists()) {
      return null;
    }

    final Response<Stream<List<int>>> response =
        new Response<Stream<List<int>>>(await f.openRead());

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
    return response;
  }
}
