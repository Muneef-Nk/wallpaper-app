class PhotoResponse {
  final int page;
  final int perPage;
  final List<Photo> photos;
  final String? nextPage;

  PhotoResponse({
    required this.page,
    required this.perPage,
    required this.photos,
    this.nextPage,
  });

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      page: json['page'],
      perPage: json['per_page'],
      photos: (json['photos'] as List).map((e) => Photo.fromJson(e)).toList(),
      nextPage: json['next_page'],
    );
  }
}

class Photo {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final String avgColor;
  final Src src;

  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.avgColor,
    required this.src,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographer: json['photographer'],
      photographerUrl: json['photographer_url'],
      avgColor: json['avg_color'],
      src: Src.fromJson(json['src']),
    );
  }
}

class Src {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;

  Src({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
  });

  factory Src.fromJson(Map<String, dynamic> json) {
    return Src(
      original: json['original'],
      large2x: json['large2x'],
      large: json['large'],
      medium: json['medium'],
      small: json['small'],
    );
  }
}
