# jaguar_static_file

## Usage

```dart

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_static_file/jaguar_static_file.dart';

@Api()
class MyApi extends _$MyApi {

      @Route(path: '/file', methods: const ["GET"])
      @WrapStaticFile()
      getFile() {
          return new JaguarFile("filePath");
      }

}
```