import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:wallpaper_app/models/model.dart';
import 'package:http/http.dart' as http;

class PhotooProvider with ChangeNotifier {
  final String _apiKey =
      "PzrwjMFFdssYI6z3sTYrAFpGwUnlnTE0Nft6rnGEsy8O6A0gKvBf6khO"; // Replace with your key.
  List<ImageModel> _photos = [];
  int _page = 1;
  bool _isLoading = false;

  List<ImageModel> get photos => _photos;
  bool get isLoading => _isLoading;

  Future<void> fetchPhotos() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse(
          'https://api.pexels.com/v1/curated?page=$_page&per_page=20');
      final response = await http.get(url, headers: {
        'Authorization': _apiKey,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<ImageModel> fetchedPhotos = (data['photos'] as List)
            .map((photoJson) => ImageModel.fromJson(photoJson))
            .toList();
        _photos.addAll(fetchedPhotos);
        _page++;
      } else {
        // Handle non-200 status codes
        debugPrint('Error: Received status code ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching photos: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadImage(
      {required String imageUrl,
      required int imageId,
      required BuildContext context}) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final bytes = response.bodyBytes;
        final directory = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        final file = File("$directory/$imageId.png");
        await file.writeAsBytes(bytes);

        MediaScanner.loadMedia(path: file.path);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("File's been saved at: ${file.path}"),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {}
  }
}
