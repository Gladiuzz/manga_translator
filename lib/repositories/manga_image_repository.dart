import 'package:dio/dio.dart';
import 'package:manga_translator/models/manga_image_model.dart';

abstract class MangaImageRepository {
  Future<MangaImageModel> uploadImage();
}

class MangaImageService implements MangaImageRepository {
  @override
  Future<MangaImageModel> uploadImage() async {
    final MangaImageModel manga = MangaImageModel();

    return manga;
  }
}
