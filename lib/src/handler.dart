part of static_file.src;

/// [RequestHandler] to serve static files from given [directory].
///
/// [path] is the route path to match against request path.
///
///       final server = new Jaguar();
///       server.addApi(new StaticFileHandler('/static/*',
///           new Directory('./example/static/')));
///       await server.serve();
///
/// Look at documentation for [path] field to learn how to use ':' and '*' path
/// segments to match request paths based on pattern.
class StaticFileHandler implements RequestHandler {
  /// The route path to match against request path
  ///
  /// Use path segment ':' to match any value for the particular path segment.
  ///
  /// Example:
  /// The path '/static/:/index.html' matches
  /// /static/one/index.html  -> directory.path + 'one/index.html'
  /// /static/1/index.html    -> directory.path + '1/index.html'
  /// etc.
  /// It does not however match
  /// /static/index.html
  /// /static/one/two/index.html
  ///
  /// Use glob path segment '*' to match current and all following request
  /// path segments.
  ///
  /// Example:
  /// The path '/static/*' matches
  /// /static/one/index.html        -> directory.path + 'one/index.html'
  /// /static/1/index.html          -> directory.path + '1/index.html'
  /// /static/index.html            -> directory.path + 'index.html'
  /// /static/one/two/index.html    -> directory.path + 'one/two/index.html'
  final String path;

  /// Route paths segments cached by splitting [path]
  final UnmodifiableListView<String> pathSegments;

  /// Directory from which the static files are served
  final Directory directory;

  StaticFileHandler(this.path, this.directory)
      : pathSegments = new UnmodifiableListView(splitPathToSegments(path));

  /// The request handler
  ///
  /// Matches the request path against route [path]. On path match, the
  /// corresponding static file from [directory] is served.
  ///
  /// Adds mimetype based on the file extension
  Future<Response<Stream<List<int>>>> handleRequest(Context ctx,
      {String prefix}) async {
    if (!matches(ctx.req.uri)) {
      return null;
    }

    final String path = getTargetUrl(ctx.req.uri);

    final f = new File(path);
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

  /// Tests if [reqUri] matches the [path]
  bool matches(Uri reqUri) {
    final List<String> reqSegs = reqUri.pathSegments;

    if (reqSegs.length < pathSegments.length) return false;

    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i].startsWith(':')) {
        if (pathSegments[i].endsWith('*') && i == (pathSegments.length - 1))
          return true;
        continue;
      }
      if (pathSegments[i] == '*' && i == (pathSegments.length - 1)) return true;

      if (pathSegments[i] != reqSegs[i]) return false;
    }

    return true;
  }

  /// Returns the path of the file inside [directory] [reqUri] points to
  String getTargetUrl(final Uri reqUri) {
    List<String> segs = reqUri.pathSegments.toList();

    if (pathSegments.length > 0) {
      if (pathSegments.last.endsWith('*')) {
        if (pathSegments.length > 1) {
          segs = segs.sublist(pathSegments.length - 1);
        }
      } else {
        segs = segs.sublist(pathSegments.length);
      }
    }

    final ctx = new p.Context();
    final path = ctx.join(directory.absolute.path, ctx.joinAll(segs));

    return path;
  }
}
