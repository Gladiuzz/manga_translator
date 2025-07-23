import 'dart:io';

import 'package:dio/dio.dart';
import 'package:manga_translator/models/manga_image_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class MangaImageRepository {
  Future<File?> uploadImage(MangaImageModel manga);
}

class MangaImageService implements MangaImageRepository {
  final Dio dio = Dio();
  // final String baseUrl = 'http://192.168.100.202:8000/translate';
  final String baseUrl = 'https://8c0a7d2c9554.ngrok-free.app/translate';

  @override
  Future<File?> uploadImage(MangaImageModel manga) async {
    try {
      final fileName = manga.path!.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(manga.path!, filename: fileName),
      });

      final response = await dio.post(
        baseUrl,
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      print("Hasil Response ${response}");

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final translatedFile = File(
          '${tempDir.path}/translated_${manga.index}_$fileName',
        );
        await translatedFile.writeAsBytes(response.data);
        return translatedFile;
      }
    } catch (e) {
      print("Error upload index ${manga.index}: $e");
    }

    return null;
  }
}
