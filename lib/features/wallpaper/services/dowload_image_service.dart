import 'dart:io';
import "package:http/http.dart" as http;

class ImageDownloadService {
  static Future<String> downloadImage(String imageUrl) async {
    try {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      String filePath =
          '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      var response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        File file = File(filePath);
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
