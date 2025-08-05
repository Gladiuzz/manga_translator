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
  final String baseUrl = 'https://b6dba0f5bb9c.ngrok-free.app/translate';

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

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final translatedFile = File(
          '${tempDir.path}/translated_${manga.index}_$fileName',
        );
        await translatedFile.writeAsBytes(response.data);
        return translatedFile;
      } else {
        throw Exception("Gagal upload: ${response.statusCode}");
      }
    } on DioError catch (e) {
      print("DioError upload index ${manga.index}: ${e.message}");

      // Lempar exception agar bisa ditangkap oleh BLoC
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.unknown ||
          e.message!.contains("Failed host lookup")) {
        throw SocketException("Tidak ada koneksi internet");
      } else {
        throw Exception("Gagal upload gambar.");
      }
    } catch (e) {
      print("Error umum upload index ${manga.index}: $e");
      throw Exception("Kesalahan tak terduga saat upload.");
    }
  }
}
