import 'dart:convert';
import 'dart:io';

import 'package:manga_translator/config/app_color.dart';
import 'package:manga_translator/config/url.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

abstract class MangaImageRepository {
  Future<List<File>> uploadImages(List<MangaImageModel> manga);
}

class MangaImageService implements MangaImageRepository {
  @override
  Future<List<File>> uploadImages(List<MangaImageModel> mangaList) async {
    try {
      // Multipart request setup
      var uri = Uri.parse(Urls.baseUrl + Urls.translate);
      var request = http.MultipartRequest('POST', uri);

      print('url : ${uri.toString()}');

      for (final manga in mangaList) {
        final fileName = manga.path!.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            manga.path!,
            filename: fileName,
          ),
        );
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data["results"] ?? [];
        final paths = List<String>.from(
          results.map((e) => e["path"] as String),
        );
        final localResults = await cacheImages(paths);

        print('hasil $localResults');
        return localResults;
      } else {
        throw Exception("Gagal upload: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      print("SocketException upload: ${e.message}");
      throw SocketException("Tidak ada koneksi internet");
    } catch (e, stack) {
      print("Error umum upload: $e\n$stack");
      throw Exception("Kesalahan tak terduga saat upload.");
    }
  }

  Future<List<File>> cacheImages(List<String> urls) async {
    final tempDir = await getTemporaryDirectory();
    List<File> cachedFiles = [];
    for (final url in urls) {
      final fileName = url.split('/').last;
      final file = File('${tempDir.path}/$fileName');
      try {
        final response = await http.get(Uri.parse(url));
        print('HTTP status: ${response.statusCode}');
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          cachedFiles.add(file);
        } else {
          print('Gagal download $url: status ${response.statusCode}');
          throw Exception('Gagal download $url: status ${response.statusCode}');
        }
      } catch (e, stack) {
        print('Gagal download $url: $e\n$stack');
        throw Exception('Gagal download $url: $e');
      }
    }
    return cachedFiles;
  }
}
