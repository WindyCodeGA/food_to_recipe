import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:typed_data';

Future<void> saveFileWeb(Uint8List bytes, String fileName) async {
  final array = bytes.toJS;
  final blob = web.Blob([array].toJS);
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = fileName;

  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
