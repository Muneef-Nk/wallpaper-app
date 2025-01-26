import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/api/api_config.dart';
import 'package:wallpaper_app/features/wallpaper/model/photo_model.dart';

class PhotoService {
  static Future<Photo> fetchPhoto(int id) async {
    final url = Uri.parse("${ApiConfig.BASEURL}/photos/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": ApiConfig.APIKEY,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Photo.fromJson(data);
    } else {
      throw Exception("Failed to load photo");
    }
  }
}
