import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/core/helper_function.dart';
import 'package:wallpaper_app/features/wallpaper/model/photo_model.dart';
import 'package:wallpaper_app/features/wallpaper/services/dowload_image_service.dart';
import 'package:wallpaper_app/features/wallpaper/services/photo_service.dart';
import 'package:wallpaper_app/features/wallpaper/services/photos_service.dart';

class WallpaperController extends ChangeNotifier {
  List<Photo> _photos = [];
  bool _isLoading = false;
  int page = 1;
  int _perPage = 10;
  String? _errorMessage;
  Photo? _photo;

  // Getters
  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Photo? get photo => _photo;

  /// Fetch list of photos
  Future<void> fetchPhotos({String? category, bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      page = 1;
      _photos.clear();
      notifyListeners();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newPhotos =
          await PhotosService.fetchPhotos(page, _perPage, category);
      if (newPhotos.isEmpty && page == 1) {
        _errorMessage = 'No photos found. Please try again later.';
      } else {
        _photos.addAll(newPhotos);
        page++;
      }
    } on SocketException {
      _errorMessage = 'Network error. Please check your internet connection.';
    } on TimeoutException {
      _errorMessage = 'Request timed out. Please try again.';
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again later.';
      debugPrint('Error fetching photos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retry fetching photos
  Future<void> retryFetchPhotos() async {
    page = 1;
    _photos.clear();
    await fetchPhotos();
  }

  /// Get a single photo by ID
  Future<void> getPhoto(int id) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _photo = await PhotoService.fetchPhoto(id);
    } on SocketException {
      _errorMessage = 'Network error. Please check your internet connection.';
    } on TimeoutException {
      _errorMessage = 'Request timed out. Please try again.';
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again later.';
      debugPrint('Error fetching photo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Download an image
  Future<void> downloadImage(String imageUrl, BuildContext context) async {
    try {
      showToast(context, 'Downloading...');
      final downloadPath = await ImageDownloadService.downloadImage(imageUrl);
      showToast(context, 'Download successful! File saved to $downloadPath');
    } catch (e) {
      showToast(context, 'Download failed!');
      debugPrint('Error downloading image: $e');
    }
    notifyListeners();
  }
}
