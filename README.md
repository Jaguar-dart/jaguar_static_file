# jaguar_static_file

Provides two ways to serve static files
  1) [`StaticFileHandler`](StaticFileHandler) : RequestHandler based
  2) [`StaticFile`](StaticFile)               : Interceptor based

# StaticFileHandler
`StaticFileHandler` is [RequestHandler](RequestHandler) based. It can be directly added to [Jaguar](Jaguar) server using 
[`addApi`](addApi) method or included in an [Api](Api) using [IncludeApi](IncludeApi) annotation.  

## Usage

```dart
Future main() async {
  final server = new Jaguar();
  server.addApi(
      new StaticFileHandler('/public/*', new Directory('./example/static/')));
  await server.serve();
}
```

# StaticFile
`StaticFile` is an interceptor that substituted [JaguarFile](JaguarFile) in response with actual content of the file 
[JaguarFile] (JaguarFile) points to.

## Usage

```dart
@Api()
class MyApi extends _$MyApi {
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
```

[JaguarFile]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/JaguarFile-class.html
[Jaguar]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Jaguar-class.html
[IncludeApi]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/IncludeApi-class.html
[Api]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Api-class.html
[RequestHandler]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/RequestHandler-class.html
[StaticFileHandler]: https://www.dartdocs.org/documentation/jaguar_static_file/latest/jaguar_static_file/StaticFileHandler-class.html
[StaticFile]: https://www.dartdocs.org/documentation/jaguar_static_file/latest/jaguar_static_file/StaticFile-class.html