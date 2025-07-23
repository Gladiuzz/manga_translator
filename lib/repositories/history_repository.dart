import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:manga_translator/models/history_model.dart';
import 'package:manga_translator/models/manga_image_model.dart';

abstract class HistoryRepository {
  Future<void> saveHistory(String title, List<MangaImageModel> imagePaths);
  Future<List<HistoryModel>> getAll();
  Future<void> deleteHistory(int id);
  Future<void> deleteMultiple(List<int> ids);
}

class HistoryService implements HistoryRepository {
  final Isar isar;

  HistoryService(this.isar);

  @override
  Future<void> saveHistory(
    String title,
    List<MangaImageModel> imagePaths,
  ) async {
    final jsonStr = jsonEncode(imagePaths.map((e) => e.toJson()).toList());

    final history = HistoryModel()
      ..title = title
      ..translateDate = DateTime.now()
      ..imagePaths = jsonStr;

    await isar.writeTxn(() async {
      await isar.historyModels.put(history);
    });
  }

  @override
  Future<List<HistoryModel>> getAll() async {
    return await isar.historyModels.where().sortByTranslateDate().findAll();
  }

  @override
  Future<void> deleteHistory(int id) async {
    await isar.writeTxn(() async {
      await isar.historyModels.delete(id);
    });
  }

  Future<void> deleteWithFiles(int id) async {
    final item = await isar.historyModels.get(id);
    if (item != null) {
      try {
        final images = (jsonDecode(item.imagePaths) as List)
            .map((e) => MangaImageModel.fromJson(e))
            .toList();

        // Dapatkan folder tempat gambar disimpan
        final firstImagePath = images.first.path;
        final folder = firstImagePath != null
            ? File(firstImagePath).parent
            : null;

        // Hapus semua file gambar
        for (var image in images) {
          final file = File(image.path ?? '');
          if (file.existsSync()) {
            await file.delete();
          }
        }

        // Hapus folder jika kosong (dan bukan null)
        if (folder != null && folder.existsSync()) {
          final contents = folder.listSync();
          if (contents.isEmpty) {
            await folder.delete();
          }
        }
      } catch (e) {
        print("Gagal menghapus file atau folder: $e");
      }

      // Hapus dari database
      await isar.writeTxn(() async {
        await isar.historyModels.delete(id);
      });
    }
  }

  @override
  Future<void> deleteMultiple(List<int> ids) async {
    for (final id in ids) {
      await deleteWithFiles(id);
    }
  }
}
