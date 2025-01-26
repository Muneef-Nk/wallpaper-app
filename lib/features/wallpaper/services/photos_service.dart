import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/api/api_config.dart';
import 'package:wallpaper_app/features/wallpaper/model/photo_model.dart';

class PhotosService {
  static Future<List<Photo>> fetchPhotos(
      int page, int perPage, String? category) async {
    final url = Uri.parse(
        "${ApiConfig.BASEURL}/search?query=$category&page=$page&per_page=$perPage");

    final response = await http.get(
      url,
      headers: {
        "Authorization": ApiConfig.APIKEY,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['photos'] as List)
          .map((json) => Photo.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load photos");
    }
  }
}
