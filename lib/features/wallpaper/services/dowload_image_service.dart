import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class ImageDownloadService {
  static Future<String> downloadImage(String imageUrl) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) throw 'Storage permission is required';

      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Directory? directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw 'Failed to download image. Status code: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error downloading image: $e';
    }
  }
}
