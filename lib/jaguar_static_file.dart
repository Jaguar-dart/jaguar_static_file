/// Provides two ways to serve static files
///   1) [StaticFileHandler]
///   2) [StaticFile]
///
/// [StaticFileHandler] is [RequestHandler] based. It can be directly added to
/// [Jaguar] server using `addApi` method or included in an [Api] using [IncludeApi]
/// annotation.
///
/// [StaticFile] is an interceptor that substituted [JaguarFile] in response with
/// actual content of the file [JaguarFile] points to.
library jaguar.static_file;

export 'src/static_file.dart';
